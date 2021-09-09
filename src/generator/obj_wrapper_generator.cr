require "./base"
require "./wrapper_util"
require "./signal_wrapper_generator"
require "./property_wrapper_generator"

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
      doc_repo.doc(io, @obj_info)
      generate_class_declaration(io)
      generate_interface_includes(io)
      generate_initialize(io)
      generate_generic_constructor(io)
      if parent.nil?
        generate_finalize(io)
        generate_to_unsafe(io)
        generate_ref_count(io)
      end
      generate_g_type_method(io, @obj_info)
      generate_casts(io)
      MethodWrapperGenerator.generate(io, @obj_info.methods)
      PropertyWrapperGenerator.generate(io, @obj_info.properties)
      generate_signals(io)
      io << "end\nend\n" # end class, end module
    end

    private def generate_class_declaration(io : IO)
      parent = @obj_info.parent

      io << "class " << to_crystal_type(@obj_info, include_namespace: false)
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
            "# :nodoc:\n" \
            "def initialize(@pointer, transfer : GICrystal::Transfer)\n"
      if @obj_info.parent.nil?
        io << "LibGObject.g_object_ref(self)  unless transfer.full?\n"
      else
        io << "super\n"
      end
      io << "end\n"
    end

    private def all_properties : Array(PropertyInfo)
      obj = @obj_info
      props = [] of PropertyInfo
      while obj
        props.concat(obj.properties)
        obj = obj.parent
      end
      props.uniq!(&.name)
    end

    private def generate_generic_constructor(io : IO)
      props = all_properties
      return if props.empty?

      io << "def initialize(*"
      props.each do |prop|
        io << "," << to_crystal_arg_decl(prop.name) << " : " << to_crystal_type(prop.type_info) << "? = nil"
      end
      io << ")\n"
      io << "_names = uninitialized Pointer(LibC::Char)[" << props.size << "]\n"
      io << "_values = StaticArray(LibGObject::Value, " << props.size << ").new(LibGObject::Value.new)\n"
      io << "_n = 0\n"
      props.each do |prop|
        prop_name = to_identifier(prop.name)
        io << "if " << prop_name << LF
        io << "(_names.to_unsafe + _n).value = \"" << prop.name << "\".to_unsafe\n"
        io << "GObject::Value.init_g_value(_values.to_unsafe + _n, " << prop_name << ")\n"
        io << "_n += 1\n"
        io << "end\n"
      end
      io << "@pointer = LibGObject.g_object_new_with_properties(" << to_crystal_type(@obj_info, include_namespace: false) <<
        ".g_type, _n, _names, _values)\n"
      io << "\nend\n"
    end

    private def generate_finalize(io : IO)
      io << "def finalize\n"
      io << "LibGObject.g_object_unref(self)\n"
      io << "end\n"
    end

    private def generate_to_unsafe(io : IO)
      io << "def to_unsafe\n" \
            "@pointer\n" \
            "end\n"
    end

    private def generate_casts(io : IO)
      type_name = to_crystal_type(@obj_info)
      io << "# Cast a `GObject::Object` to `" << type_name << "`, throw `TypeCastError` if cast can't be made.\n"
      io << "def self.cast(obj : GObject::Object)\n"
      io << "  cast?(obj) || raise TypeCastError.new(\"can't cast \#{typeof(obj).name} to " << type_name << "\")\n"
      io << "end\n"

      io << "# Cast a `GObject::Object` to `" << type_name << "`, returns nil if cast can't be made.\n"
      io << "def self.cast?(obj : GObject::Object)\n"
      io << "  return if LibGObject.g_type_check_instance_is_a(obj, g_type).zero?\n"
      io << "  new(obj.to_unsafe, GICrystal::Transfer::None)\n"
      io << "end\n"
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

    private def generate_signals(io : IO)
      @obj_info.signals.each do |signal|
        SignalWrapperGenerator.new(@obj_info, signal).generate(io)
      end
    end
  end
end
