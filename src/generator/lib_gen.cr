module Generator
  class LibGen < FileGen
    def filename : String
      "lib_#{namespace.name.underscore}.cr"
    end

    private def libraries : Array(String)
      namespace.shared_libraries.map do |library|
        library[/lib([^\/]+)(?:\.so|-.+?\.dll|\..+?\.dylib).*/, 1]
      end
    end

    # Return all functions alphabetically sorted
    private def all_functions : Array(String)
      all = [] of String

      {% for attr in %w(objects interfaces structs) %}
        namespace.{{ attr.id }}.each do |obj|
          obj.methods.each do |func|
            all << generate_c_function(func) unless config.lib_ignore?(func.symbol)
          end
        end
      {% end %}

      # Type init functions
      {% for attr in %w(objects interfaces structs enums flags) %}
        namespace.{{ attr.id }}.each do |obj|
          all << type_init_func(obj) if obj.type_init
        end
      {% end %}

      namespace.functions.each do |func|
        all << generate_c_function(func) unless config.lib_ignore?(func.symbol)
      end
      all.sort_by!(&.lines.last)
    end

    private def type_init_func(info : RegisteredTypeInfo)
      "fun #{info.type_init} : UInt64"
    end

    private def generate_c_function(func_info : FunctionInfo) : String
      symbol = func_info.symbol
      with_log_scope("#{to_lib_namespace(func_info.namespace)}.#{symbol}") do
        String.build do |io|
          io << "@[Raises]\n" if symbol.in?(@config.execute_callback)
          io << "fun " << symbol
          generate_c_function_args(io, func_info)
          io << " : " << to_lib_type(func_info.return_type, structs_as_void: true)
        end
      end
    end

    private def generate_c_function_args(io : IO, func_info : FunctionInfo)
      func_namespace = func_info.namespace.name
      flags = func_info.flags

      lib_args = [] of String
      lib_args << "this : Void*" if flags.method?
      func_info.args.each do |arg|
        include_namespace = func_namespace != arg.type_info.interface.try(&.namespace).try(&.name)
        arg_type = to_lib_type(arg.type_info, structs_as_void: true, include_namespace: include_namespace, is_arg: true)
        arg_type = "Pointer(#{arg_type})" unless arg.direction.in?
        lib_args << "#{to_identifier(arg.name)} : #{arg_type}"
      end
      lib_args << "error : LibGLib::Error**" if flags.throws?

      io << "(" << lib_args.join(", ") << ")"
    end

    private def callback_signature(callback : CallbackInfo) : String
      String.build do |s|
        callback.args.join(s, ", ") do |arg, iio|
          iio << to_lib_type(arg.type_info)
        end
        s << " -> " << to_lib_type(callback.return_type)
      end
    end
  end
end
