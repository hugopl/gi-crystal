module Generator
  class SignalWrapperGenerator < Base
    @obj : ObjectInfo
    @signal : SignalInfo
    @signal_args : Array(ArgInfo)?

    def initialize(@obj : ObjectInfo, @signal : SignalInfo)
      super(@obj.namespace)
    end

    def filename : String?
    end

    def subject : String
      signal_type
    end

    private def signal_type
      "#{@signal.name.tr("-", "_").camelcase}Signal"
    end

    def do_generate(io : IO)
      generate_signal_object(io)
      generate_signal_method(io)
    end

    def generate_signal_method(io)
      io << "def " << to_method_name(@signal.name) << "_signal" << LF
      io << signal_type << ".new(self)\n"
      io << "end\n"
    end

    def generate_signal_object(io : IO)
      obj = <<-EOT
      struct #{signal_type}
        @source : GObject::Object
        @detail : String?

        def initialize(@source, @detail = nil)
        end

        def [](detail : String) : self
          raise ArgumentError.new("This signal already have a detail") if @detail
          self.class.new(@source, detail)
        end

        def name
          @detail ? "#{@signal.name}::\#{@detail}" : "#{@signal.name}"
        end

        def connect(&block : Proc(#{lean_proc_params}))
          connect(block)
        end

        def connect_after(&block : Proc(#{lean_proc_params}))
          connect(block)
        end

        def connect(block : Proc(#{lean_proc_params}))
          box = ::Box.box(block)
          slot = #{lean_slot}
          LibGObject.g_signal_connect_data(@source, name, slot.pointer,
            GICrystal::ClosureDataManager.register(box), ->GICrystal::ClosureDataManager.deregister, 0)
        end

        def connect_after(block : Proc(#{lean_proc_params}))
          box = ::Box.box(block)
          slot = #{lean_slot}
          LibGObject.g_signal_connect_data(@source, name, slot.pointer,
            GICrystal::ClosureDataManager.register(box), ->GICrystal::ClosureDataManager.deregister, 1)
        end

        def connect(block : Proc(#{full_proc_params}))
          box = ::Box.box(block)
          slot = #{full_slot}
          LibGObject.g_signal_connect_data(@source, name, slot.pointer,
            GICrystal::ClosureDataManager.register(box), ->GICrystal::ClosureDataManager.deregister, 0)
        end

        def connect_after(block : Proc(#{full_proc_params}))
          box = ::Box.box(block)
          slot = #{full_slot}
          LibGObject.g_signal_connect_data(@source, name, slot.pointer,
            GICrystal::ClosureDataManager.register(box), ->GICrystal::ClosureDataManager.deregister, 1)
        end

        def emit(*args)
        end
      end

      EOT
      io << obj
    end

    private def has_return_value?
      !@signal.return_type.tag.void?
    end

    private def signal_args
      @signal_args ||= @signal.args.reject do |arg|
        Config.for(arg.namespace.name).ignore?(to_crystal_type(arg.type_info, false))
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
        s << "sender = " << convert_to_crystal("lib_sender", @obj, :none) << LF
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

        io << "arg" << j << " = " << convert_to_crystal("lib_arg#{i}", arg.type_info, :none) << LF
        j += 1
      end
    end
  end
end