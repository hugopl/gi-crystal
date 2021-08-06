require "./base"
require "./wrapper_util"

module Generator
  class ObjWrapperGenerator < Base
    include WrapperUtil

    @namespace : Namespace
    @obj_info : ObjectInfo

    def initialize(@namespace : Namespace, @obj_info : ObjectInfo)
    end

    def filename : String?
      "#{@obj_info.name.underscore}.cr"
    end

    def subject : String
      @obj_info.name
    end

    def do_generate(io : IO)
      parent = @obj_info.parent
      generate_require_calls(io)

      io << "module " << to_type_name(@namespace.name) << LF
      generate_class_declaration(io)
      generate_interface_includes(io)
      generate_initialize(io)
      if parent.nil?
        generate_to_unsafe(io)
      end
      generate_method_wrappers(io, @obj_info.methods)
      generate_property_wrappers(io)
      generate_signals(io)
      io << "end\nend\n" # end class, end module
    end

    private def generate_class_declaration(io : IO)
      parent = @obj_info.parent

      io << "class " << to_lib_type(@obj_info, include_namespace: false)
      if parent
        include_namespace = parent.namespace != @namespace
        io << " < " << to_crystal_type(parent, include_namespace)
      end
      io << LF
    end

    private def generate_interface_includes(io : IO)
      my_namespace = @obj_info.namespace
      @obj_info.interfaces.each do |iface|
        include_namespace = my_namespace != iface.namespace
        io << "include " << to_crystal_type(iface, include_namespace) << LF
      end
    end

    private def generate_initialize(io : IO)
      io << "@pointer : Pointer(Void)\n" \
            "@transfer : GICrystal::Transfer\n" \
            "def initialize(@pointer, @transfer)\nend\n"
    end

    private def generate_to_unsafe(io : IO)
      io << "def to_unsafe\n" \
            "@pointer\n" \
            "end\n"
    end

    private def generate_require_calls(io : IO)
      parent = @obj_info.parent
      generate_require_call(io, parent) if parent
      @obj_info.interfaces.each do |iface|
        generate_require_call(io, iface)
      end
    end

    private def generate_require_call(io : IO, info : BaseInfo)
      io << "require \"."
      if info.namespace != @obj_info.namespace
        namespace_gen = ModuleWrapperGenerator.load(info.namespace.name)
        io << "./" << namespace_gen.module_dir
      end
      io << '/' << info.name.underscore << "\"\n"
    end

    private def generate_property_wrappers(io : IO)
      @obj_info.properties.each do |prop|
        flags = prop.flags
        generate_property_setter(io, prop) if flags.writable?
        generate_property_getter(io, prop) if flags.readable?
      end
    end

    private def generate_property_setter(io : IO, prop : PropertyInfo)
      type = to_crystal_type(prop.type_info)
      io << "def " << to_method_name(prop.name) << "=(value : " << type << ") : " << type << LF
      io << "LibGObject.g_object_set(self, \"" << prop.name << "\", value, Pointer(Void).null)\n"
      io << "value\n"
      io << "end\n"
    end

    private def generate_property_getter(io : IO, prop : PropertyInfo)
      type_info = prop.type_info
      type = to_crystal_type(type_info)
      io << "# " << prop.ownership_transfer << LF
      io << "def " << to_method_name(prop.name) << " : " << type << LF
      io << "value = uninitialized " << to_lib_type(prop.type_info) << LF
      io << "LibGObject.g_object_get(self, \"" << prop.name << "\", pointerof(value), Pointer(Void).null)\n"
      io << convert_to_crystal("value", type_info, prop.ownership_transfer) << LF
      io << "end\n"
    end

    private def generate_signals(io : IO)
      @obj_info.signals.each do |signal|
        generate_signal(io, signal)
      end
    end

    private def generate_signal(io : IO, signal : SignalInfo)
      io << "def " << to_method_name(signal.name) << "_signal" << LF
      generate_signal_impl(io, signal)
      io << "end\n"
    end

    private def generate_signal_impl(io : IO, signal : SignalInfo)
      signal_name = signal.name

      slot_c_args = String.build do |s|
        s << "lib_sender : Pointer(Void)"
        signal.args.each_with_index do |arg, i|
          s << ", lib_arg" << i << " : " << to_lib_type(arg.type_info)
        end
        s << ", box : Pointer(Void)"
      end

      crystal_return_type = to_crystal_type(signal.return_type)

      slot_crystal_proc_params = String.build do |s|
        signal.args.each do |arg|
          s << to_crystal_type(arg.type_info) << ", "
        end
        s << crystal_return_type
      end

      crystal_box_args = signal.args.size.times.map { |i| "arg#{i}" }.join(",")

      io << "full_slot = ->(" << slot_c_args << ") {\n"
      io << "sender = " << convert_to_crystal("lib_sender", @obj_info, :none) << LF
      generate_signal_args_conversion(io, signal)
      io << "::Box(Proc(" << to_crystal_type(@obj_info) << "," << slot_crystal_proc_params << ")).unbox(box).call(sender, "
      io << crystal_box_args << ")"
      io << ".to_unsafe" unless crystal_return_type == "Nil"
      io << "\n}\n"

      io << "lean_slot = ->(" << slot_c_args << ") {\n"
      generate_signal_args_conversion(io, signal)
      io << "::Box(Proc(" << slot_crystal_proc_params << ")).unbox(box).call("<< crystal_box_args << ")"
      io << ".to_unsafe" unless crystal_return_type == "Nil"
      io << "\n}\n"

      io << "GObject::Signal("
      io << to_crystal_type(@obj_info) << ","
      io << to_crystal_type(signal.return_type)
      signal.args.each do |arg|
        io << "," << to_crystal_type(arg.type_info)
      end
      io << ").new(to_unsafe, \"" << signal.name << "\",\nfull_slot.pointer,\nlean_slot.pointer)\n"
    end

    def generate_signal_args_conversion(io : IO, signal : SignalInfo)
      signal.args.each_with_index do |arg, i|
        io << "arg" << i << " = " << convert_to_crystal("lib_arg#{i}", arg.type_info, :none) << LF
      end
    end
  end
end
