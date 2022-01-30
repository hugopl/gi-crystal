module Generator
  class SignalGen < Generator
    include WrapperUtil

    @obj : ObjectInfo
    getter signal : SignalInfo
    @signal_args : Array(ArgInfo)?

    def initialize(@obj : ObjectInfo, @signal : SignalInfo)
      super(@obj.namespace)
    end

    def filename : String?
    end

    def subject : String
      "#{@obj.name}::#{signal_type}"
    end

    def scope
      "#{@obj.namespace.name}::#{@obj.name} #{@signal.name} signal"
    end

    private def signal_type
      "#{@signal.name.tr("-", "_").camelcase}Signal"
    end

    private def has_return_value?
      !@signal.return_type.tag.void?
    end

    private def signal_args
      @signal_args ||= @signal.args.reject do |arg|
        BindingConfig.for(arg.namespace).ignore?(to_crystal_type(arg.type_info, false))
      end
    end

    private def lean_proc_params
      String.build do |s|
        signal_args.each do |arg|
          s << to_crystal_type(arg.type_info) << ","
        end
        s << to_crystal_type(@signal.return_type)
      end
    end

    private def full_proc_params
      String.build do |s|
        s << to_crystal_type(@obj, true) << ","
        signal_args.each do |arg|
          s << to_crystal_type(arg.type_info, true) << ","
        end
        s << to_crystal_type(@signal.return_type, true)
      end
    end

    private def slot_c_args
      String.build do |s|
        s << "lib_sender : Pointer(Void)"
        @signal.args.each_with_index do |arg, i|
          arg_type = to_lib_type(arg.type_info, structs_as_void: true)
          # If arg_type is Void, it's probably a struct, GObjIntrospection doesn't inform that signal args are pointer when
          # they are structs
          arg_type = "Pointer(#{arg_type})" if arg_type == "Void"
          s << ", lib_arg" << i << " : " << arg_type
        end
        s << ", box : Pointer(Void)"
      end
    end

    private def lean_slot
      String.build do |s|
        s << "->(" << slot_c_args << ") {\n"
        generate_signal_args_conversion(s)
        s << "::Box(Proc(" << slot_crystal_proc_params << ")).unbox(box).call(" << crystal_box_args << ")"
        s << ".to_unsafe" if has_return_value?
        s << "\n}\n"
      end
    end

    private def full_slot
      String.build do |s|
        s << "->(" << slot_c_args << ") {\n"
        s << "sender = " << convert_to_crystal("lib_sender", @obj, @signal.args, :none) << LF
        generate_signal_args_conversion(s)
        s << "::Box(Proc(" << to_crystal_type(@obj) << "," << slot_crystal_proc_params << ")).unbox(box).call(sender, "
        s << crystal_box_args << ")"
        s << ".to_unsafe" if has_return_value?
        s << "\n}\n"
      end
    end

    private def slot_crystal_proc_params
      String.build do |s|
        signal_args.each do |arg|
          s << to_crystal_type(arg.type_info) << ", "
        end
        s << to_crystal_type(@signal.return_type)
      end
    end

    private def crystal_box_args
      signal_args.size.times.map { |i| "arg#{i}" }.join(",")
    end

    private def generate_signal_args_conversion(io : IO)
      j = 0
      @signal.args.each_with_index do |arg, i|
        next unless signal_args.includes?(arg)

        io << "arg" << j << " = " << convert_to_crystal("lib_arg#{i}", arg.type_info, @signal.args, :none) << LF
        j += 1
      end
    end

    private def signal_emit_method : String
      String.build do |s|
        arg_vars = signal_args.map { |arg| to_identifier(arg.name) }

        # Emit declaration
        s << "def emit("
        s << signal_args.map_with_index do |arg, i|
          "#{arg_vars[i]} : #{to_crystal_type(arg.type_info, is_arg: true)}"
        end.join(",")
        s << ") : Nil\n"

        generate_handmade_types_param_conversion(s, signal_args)

        # Signal emission
        s << "LibGObject.g_signal_emit_by_name(@source, \"" << @signal.name << "\""
        arg_vars.each do |arg|
          s << ", " << arg
        end
        s << ")\n"
        s << "end\n"
      end
    end
  end
end
