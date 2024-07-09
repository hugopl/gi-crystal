require "./arg_strategy"
require "./callable_gen"

module Generator
  class MethodGen < CallableGen
    include WrapperUtil

    alias MethodReturnType = TypeInfo | ArgInfo

    private getter method : FunctionInfo
    getter object : RegisteredTypeInfo | Namespace
    @method_return_type : MethodReturnType?
    @args_strategies : Array(ArgStrategy)
    @crystal_arg_count = 0

    def initialize(@object, @method)
      super(@method.namespace)
      args_strategies = nil
      with_log_scope(@method.symbol) do
        args_strategies = ArgStrategy.find_strategies(@method, :crystal_to_c)
      end
      @args_strategies = args_strategies.not_nil!
      @crystal_arg_count = @args_strategies.size - @args_strategies.count(&.remove_from_declaration?)
    end

    def scope
      @method.symbol
    end

    def throws? : Bool
      @method.flags.throws?
    end

    private def method_identifier : String
      identifier = to_call(@method.name)
      method_flags = @method.flags
      identifier = if method_flags.constructor?
                     "self.#{identifier}"
                   elsif identifier.starts_with?("get_") && identifier.size > 4
                     identifier[4..]
                   elsif method_flags.getter? && identifier.starts_with?("is_") && identifier.size > 3
                     "#{identifier}?"
                   elsif @crystal_arg_count == 1 && identifier.starts_with?("set_") && identifier.size > 4
                     "#{identifier[4..]}="
                   else
                     identifier
                   end
      # No flags means static methods
      identifier = "self.#{identifier}" if method_flags.none?
      identifier
    end

    macro render_args_declaration
      render_args_declaration(io)
    end

    def render_args_declaration(io : IO)
      @args_strategies.each(&.render_declaration(io))
    end

    macro render_args_preparation
      render_args_preparation(io)
    end

    def render_args_preparation(io : IO)
      @args_strategies.each(&.write_implementation(io))
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

    private def method_return_type_declaration : String
      if @method.flags.constructor?
        return @method.may_return_null? ? ": self?" : ": self"
      end

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
      args = @method.args
      String.build do |io|
        io << "# " << @method.symbol << ": (" << @method.flags.to_s << ")\n"
        args_gi_annotations(io, args)

        io << "# Returns: (transfer " << @method.caller_owns.to_s.downcase
        return_type = @method.return_type
        io << ") (filename" if return_type.tag.filename?
        io << ") (nullable" if @method.may_return_null?
        io << ") "
        type_info_gi_annotations(io, @method.return_type, args)
        io << LF
      end
    end

    private def method_c_call_args : String
      args = Array(String).new(@method.args.size + 2) # +2, just in case we need space for `self` and `error`.
      args << "to_unsafe" if @method.method?
      @method.args.each do |arg|
        if arg.direction.out? && arg_used_by_return_type?(arg)
          args << "pointerof(#{to_identifier(arg.name)})"
        else
          args << to_identifier(arg.name)
        end
      end
      args << "pointerof(_error)" if throws?
      args.join(", ")
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
        if @method.constructor?
          s << convert_to_crystal("_retval", @method.container.not_nil!, @method.args, :full)
        elsif return_type.is_a?(ArgInfo)
          s << to_identifier(return_type.name)
        elsif return_type.is_a?(TypeInfo)
          s << convert_to_crystal("_retval", return_type, @method.args, @method.caller_owns)
        end
        s << " unless _retval.null?" if @method.may_return_null?
        s << LF
      end
    end

    def arg_used_by_return_type?(arg : ArgInfo) : Bool
      arg_index = @method.args.index(arg)
      return false unless arg_index

      type_info = @method.return_type
      type_info.tag.array? && type_info.array_length == arg_index
    end

    # If the method only receive a array as argument, create a splat overload, so if
    # `def foo(bar : Enumerable(String))` exists, `def foo(*bar : String)` will also be generated.
    def method_splat_overload : String?
      return if @crystal_arg_count != 1 || method_identifier.ends_with?("=")

      # Check if the method receives onlyl one array parameter
      arg = @args_strategies.find { |strategy| !strategy.remove_from_declaration? }.try(&.arg)
      return if arg.nil? || !arg.type_info.tag.array?

      param_type = to_crystal_type(arg.type_info.param_type, is_arg: true)
      String.build do |s|
        s << "def " << method_identifier << "(*" << to_identifier(arg.name) << " : " << param_type << ")\n"
        s << method_identifier << "(" << to_identifier(arg.name) << ")\n"
        s << "end\n"
      end
    end
  end
end
