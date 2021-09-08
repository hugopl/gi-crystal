require "./wrapper_util"

module Generator
  class MethodWrapperGenerator < Base
    include WrapperUtil

    @method_info : FunctionInfo
    @method_args : Array(ArgInfo)?
    @method_identifier : String?
    @return_type : TypeInfo | ArgInfo | Nil

    def initialize(@method_info : FunctionInfo)
      super(@method_info.namespace)
    end

    def self.generate(io : IO, methods : Array(FunctionInfo))
      methods.each do |func|
        next if func.deprecated?

        gen = MethodWrapperGenerator.new(func)
        gen.generate(io)
      end
    end

    def do_generate(io : IO)
      symbol = @method_info.symbol

      find_return_type

      generate_gi_flags_comments(io)
      generate_method_declaration(io)
      generate_method_wrapper_impl(io)
      io << "end\n"
      generate_method_splat_overload(io)
    rescue e : Error
      raise Error.new("Error generating binding for #{symbol}: #{e.message}")
    end

    def filename : String?
    end

    def subject : String
      @method_info.symbol
    end

    private def constructor?
      @method_info.flags.constructor?
    end

    private def find_return_type
      ret_type = @method_info.return_type
      out_arg = @method_info.args.find do |arg|
        arg.direction.out? && arg.caller_allocates? && !arg.type_info.array?
      end

      if out_arg
        @return_type = out_arg
      elsif !ret_type.tag.void?
        @return_type = ret_type
      end
    end

    private def generate_gi_flags_comments(io : IO)
      tags = [] of String
      args = @method_info.args
      io << "# Kind: " << @method_info.flags.to_s << LF
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

        io << "# " << arg.name << ": " << tags.join(" ") << LF if tags.any?
        tags.clear
      end
      io << "# Returns: (transfer " << @method_info.caller_owns.to_s.downcase << ")\n" unless @method_info.caller_owns.none?
    end

    private def method_identifier : String
      @method_identifier ||= begin
        identifier = to_identifier(@method_info.name)
        identifier = if constructor?
                       if identifier == "new"
                         "initialize"
                       else
                         "self.#{identifier}"
                       end
                     elsif identifier.starts_with?("get_") && identifier.size > 4
                       identifier[4..]
                     elsif @method_info.args.size == 1 && identifier.starts_with?("set_") && identifier.size > 4
                       "#{identifier[4..]}="
                     else
                       identifier
                     end
        # No flags means static methods
        identifier = "self.#{identifier}" if @method_info.flags.none?
        identifier
      end
    end

    private def generate_method_declaration(io : IO)
      io << "[@Deprecated]\n" if @method_info.deprecated?
      io << "def " << method_identifier
      generate_method_wrapper_args(io, method_args) if method_args.any?
      if constructor?
        io << LF
        return
      end

      return_type = @return_type
      nullable = false
      type = if return_type.nil? || constructor?
               "Nil"
             elsif return_type.is_a?(ArgInfo) # If we got here, the return value is an out parameter
               to_crystal_type(return_type.type_info)
             elsif return_type.is_a?(TypeInfo)
               nullable = @method_info.may_return_null?
               to_crystal_type(return_type)
             end
      io << " : " << type
      io << '?' if nullable
      io << LF
    end

    private def method_args
      @method_args ||= begin
        args = @method_info.args.dup
        args_to_remove = [] of ArgInfo
        args.each do |arg|
          type_info = arg.type_info
          iface = type_info.interface
          if iface && Config.for(arg.namespace.name).ignore?(iface.name)
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

    def generate_method_wrapper_impl(io : IO)
      if @method_info.args.any?
        generate_lenght_param_impl(io)
        generate_optional_param_impl(io)
        generate_nullable_and_arrays_params(io)
        generate_array_param_impl(io)
        generate_caller_allocates_param_impl(io)
        generate_handmade_types_param_conversion(io, method_args)
        generate_g_ref_on_transfer_full_param(io)
      end

      generate_return_variable(io)
      generate_lib_call(io)
      if constructor?
        call = method_identifier
        call = "new" if method_identifier != "initialize"
        io << call << "(_ptr, GICrystal::Transfer::Full)\n"
      else
        generate_return_value(io)
      end
    end

    def generate_lenght_param_impl(io : IO)
      args = @method_info.args
      args.each do |arg|
        arg_type = arg.type_info
        if arg_type.array_length >= 0
          io << to_identifier(args[arg_type.array_length].name) << " = " << to_identifier(arg.name)
          io << (arg.nullable? ? ".try(&.size) || 0" : ".size") << LF
        end
      end
    end

    def generate_optional_param_impl(io : IO)
      @method_info.args.each do |arg|
        next unless arg.optional?

        type_name = to_lib_type(arg.type_info, structs_as_void: true)
        io << to_identifier(arg.name) << " = " << "Pointer(" << type_name << ").null\n"
      end
    end

    def generate_nullable_and_arrays_params(io : IO)
      args = @method_info.args
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
      @method_info.args.each do |arg|
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
      return_type = @return_type
      if return_type.is_a?(ArgInfo)
        io << to_identifier(return_type.name) << "=" << to_crystal_type(return_type.type_info) << ".new\n"
      end
    end

    def generate_return_variable(io : IO)
      flags = @method_info.flags
      return_type_info = @method_info.return_type
      if flags.constructor?
        io << "_ptr = "
      elsif !return_type_info.void?
        io << "_retval = "
      end
    end

    def generate_lib_call(io : IO)
      flags = @method_info.flags

      io << to_lib_type(@method_info, include_namespace: true) << "("
      call_args = [] of String
      call_args << "self" if flags.method?

      @method_info.args.each do |arg|
        call_args << to_identifier(arg.name)
      end
      call_args.join(", ", io)
      io << ")"
      io << ".as(Pointer(Void))" if flags.constructor?
      io << LF
    end

    def generate_return_value(io : IO)
      return_type = @return_type
      return if return_type.nil?

      expr = if return_type.is_a?(ArgInfo)
               to_identifier(return_type.name)
             elsif return_type.is_a?(TypeInfo)
               convert_to_crystal("_retval", return_type, @method_info.caller_owns)
             end
      if expr != "_retval"
        io << expr
        io << " if _retval" if @method_info.may_return_null?
      end
      io << LF
    end

    # If the method only receive a array as argument, create a splat overload, so if
    # `def foo(bar : Enumerable(String))` exists, `def foo(*bar : String)` will also be generated.
    def generate_method_splat_overload(io : IO)
      return if method_args.size != 1
      arg = method_args.first

      return unless arg.type_info.tag.array?
      return if method_identifier.ends_with?("=")

      param_type = to_crystal_type(arg.type_info.param_type, is_arg: true)
      io << "def " << method_identifier << "(*" << to_identifier(arg.name) << " : " << param_type << ")\n"
      io << method_identifier << "(" << to_identifier(arg.name) << ")\n"
      io << "end\n"
    end

    def generate_g_ref_on_transfer_full_param(io : IO)
      method_args.each do |arg|
        next if !arg.ownership_transfer.full? || !arg.type_info.tag.interface?

        io << "LibGObject.g_object_ref(" << to_identifier(arg.name) << ")\n"
      end
    end
  end
end
