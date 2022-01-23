module Generator
  class MethodGen < Generator
    include WrapperUtil

    alias MethodReturnType = TypeInfo | ArgInfo

    private getter method : FunctionInfo
    @method_args : Array(ArgInfo)?
    @method_return_type : MethodReturnType?

    def initialize(@method)
      super(@method.namespace)
    end

    def ignore?
      config.ignore?(@method.symbol)
    end

    def scope
      @method.symbol
    end

    def throws? : Bool
      @method.flags.throws?
    end

    private def method_identifier : String
      identifier = to_identifier(@method.name)
      method_flags = @method.flags
      identifier = if method_flags.constructor?
                     @method.name == "new" ? "initialize" : "self.#{identifier}"
                   elsif identifier.starts_with?("get_") && identifier.size > 4
                     identifier[4..]
                   elsif method_flags.getter? && identifier.starts_with?("is_") && identifier.size > 3
                     "#{identifier}?"
                   elsif @method.args.size == 1 && identifier.starts_with?("set_") && identifier.size > 4
                     "#{identifier[4..]}="
                   else
                     identifier
                   end
      # No flags means static methods
      identifier = "self.#{identifier}" if method_flags.none?
      identifier
    end

    private def method_args : Array(ArgInfo)
      @method_args ||= begin
        args = @method.args.dup
        args_to_remove = [] of ArgInfo
        args.each do |arg|
          type_info = arg.type_info
          iface = type_info.interface
          if iface && BindingConfig.for(arg.namespace).ignore?(iface.name)
            Log.warn { "method using ignored type #{to_crystal_type(iface, true)} on arguments" }
          end

          if type_info.array_length >= 0
            args_to_remove << args[type_info.array_length]
          elsif arg.optional? || (arg.direction.out? && arg.caller_allocates? && !arg.type_info.array?)
            args_to_remove << arg
          end
        end
        args -= args_to_remove
      end
    end

    private def method_args_declaration : String
      String.build do |s|
        s << method_args.map do |arg|
          null_mark = "?" if arg.nullable?
          type = to_crystal_type(arg.type_info, is_arg: true)
          "#{to_crystal_arg_decl(arg.name)} : #{type}#{null_mark}"
        end.join(", ")
      end
    end

    private def method_return_type : MethodReturnType
      @method_return_type ||= begin
        ret_type = @method.return_type
        out_arg = @method.args.find do |arg|
          arg.direction.out? && arg.caller_allocates? && !arg.type_info.array?
        end

        if out_arg
          out_arg
        else
          ret_type
        end
      end
    end

    private def initialize_method? : Bool
      @method.constructor? && @method.name == "new"
    end

    private def method_return_type_declaration : String?
      return if initialize_method?

      return_type = method_return_type
      nullable = false
      type = if return_type.is_a?(ArgInfo) # If we got here, the return value is an out parameter
               to_crystal_type(return_type.type_info)
             elsif return_type.is_a?(TypeInfo)
               nullable = @method.may_return_null?
               if return_type.tag.filename?
                 "::Path"
               else
                 to_crystal_type(return_type)
               end
             else
               "Nil"
             end
      nullable ? ": #{type}?" : ": #{type}"
    end

    private def method_gi_annotations : String
      tags = [] of String
      args = @method.args
      String.build do |io|
        io << "# " << @method.symbol << ": (" << @method.flags.to_s << ")\n"
        args.each do |arg|
          tags << "(#{arg.direction.to_s.downcase})" unless arg.direction.in?
          tags << "(transfer #{arg.ownership_transfer.to_s.downcase})" unless arg.ownership_transfer.none?
          tags << "(nullable)" if arg.nullable?
          tags << "(caller-allocates)" if arg.caller_allocates?
          tags << "(optional)" if arg.optional?
          arg_type = arg.type_info
          if arg_type.tag.array?
            tags << String.build do |s|
              s << "(array"
              s << " length=" << args[arg_type.array_length].name if arg_type.array_length >= 0
              s << " fixed-size=" << arg_type.array_fixed_size if arg_type.array_fixed_size > 0
              s << " zero-terminated=1" if arg_type.array_zero_terminated?
              s << " element-type #{arg_type.param_type.tag}"
              s << ")"
            end
          end

          io << "# @" << arg.name << ": " << tags.join(" ") << LF if tags.any?
          tags.clear
        end

        io << "# Returns: (transfer " << @method.caller_owns.to_s.downcase
        return_type = @method.return_type
        io << " Filename" if return_type.tag.filename?
        io << ")\n"
      end
    end

    private def method_c_call_args : String
      is_method = @method.method?
      String.build do |s|
        s << "self, " if is_method
        @method.args.each_with_index do |arg, i|
          s << ',' unless i.zero?
          s << to_identifier(arg.name)
        end

        if throws?
          s << ", " unless is_method
          s << "pointerof(_error)"
        end
      end
    end

    def method_c_call : String
      c_return_type_info = @method.return_type

      String.build do |s|
        s << "_retval = " if !c_return_type_info.tag.void? || c_return_type_info.pointer?
        s << to_lib_type(method, true) << '(' << method_c_call_args << ")\n"
      end
    end

    def method_return : String
      return_type = method_return_type

      String.build do |s|
        if initialize_method?
          s << "@pointer = _retval"
          s << "\nLibGObject.g_object_ref(_retval)" if @method.caller_owns.none?
        elsif @method.constructor?
          s << convert_to_crystal("_retval", @method.container.not_nil!, :full)
        elsif return_type.is_a?(ArgInfo)
          s << to_identifier(return_type.name)
        elsif return_type.is_a?(TypeInfo)
          s << convert_to_crystal("_retval", return_type, @method.caller_owns)
        end
        s << " unless _retval.null?" if @method.may_return_null?
        s << LF
      end
    end

    def handle_method_parameters : String
      return "" if @method.args.empty?

      String.build do |s|
        generate_lenght_param_impl(s)
        generate_optional_param_impl(s)
        generate_nullable_and_arrays_params(s)
        generate_array_param_impl(s)
        generate_caller_allocates_param_impl(s)
        generate_handmade_types_param_conversion(s, method_args)
        generate_g_ref_on_transfer_full_param(s)
      end
    end

    # TODO: REFACTOR ALL CODE BELLOW
    def generate_lenght_param_impl(io : IO)
      args = @method.args
      args.each do |arg|
        arg_type = arg.type_info
        if arg_type.array_length >= 0
          io << to_identifier(args[arg_type.array_length].name) << " = " << to_identifier(arg.name)
          io << (arg.nullable? ? ".try(&.size) || 0" : ".size") << LF
        end
      end
    end

    def generate_optional_param_impl(io : IO)
      @method.args.each do |arg|
        next unless arg.optional?

        type_name = to_lib_type(arg.type_info, structs_as_void: true)
        io << to_identifier(arg.name) << " = " << "Pointer(" << type_name << ").null\n"
      end
    end

    def generate_nullable_and_arrays_params(io : IO)
      args = @method.args
      args.each do |arg|
        next unless arg.nullable?

        arg_name = to_identifier(arg.name)
        generate_null_guard(io, arg_name, arg.type_info, nullable: arg.nullable?) do
          if arg.type_info.array?
            generate_array_to_unsafe(io, arg_name, arg.type_info)
          else
            io << arg_name << ".to_unsafe"
          end
        end
      end
    end

    private def generate_array_param_impl(io : IO)
      @method.args.each do |arg|
        next if arg.nullable?

        if arg.type_info.array?
          arg_name = to_identifier(arg.name)
          io << arg_name << " = "
          generate_array_to_unsafe(io, arg_name, arg.type_info)
          io << LF
        end
      end
    end

    private def generate_caller_allocates_param_impl(io : IO)
      return_type = method_return_type
      if return_type.is_a?(ArgInfo)
        io << to_identifier(return_type.name) << "=" << to_crystal_type(return_type.type_info) << ".new\n"
      end
    end

    # If the method only receive a array as argument, create a splat overload, so if
    # `def foo(bar : Enumerable(String))` exists, `def foo(*bar : String)` will also be generated.
    def method_splat_overload : String?
      return if method_args.size != 1

      arg = method_args.first

      return unless arg.type_info.tag.array?
      return if method_identifier.ends_with?("=")

      param_type = to_crystal_type(arg.type_info.param_type, is_arg: true)
      String.build do |s|
        s << "def " << method_identifier << "(*" << to_identifier(arg.name) << " : " << param_type << ")\n"
        s << method_identifier << "(" << to_identifier(arg.name) << ")\n"
        s << "end\n"
      end
    end

    def generate_g_ref_on_transfer_full_param(io : IO)
      method_args.each do |arg|
        next if !arg.ownership_transfer.full? || !arg.type_info.tag.interface?

        io << "LibGObject.g_object_ref(" << to_identifier(arg.name) << ")\n"
      end
    end
  end
end
