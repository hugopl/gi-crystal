require "./wrapper_util"

module Generator
  class PropertyWrapperGenerator < Base
    include WrapperUtil

    @prop : PropertyInfo

    def initialize(@prop)
      super(@prop.namespace)
    end

    def filename : String?
    end

    def subject : String
      "#{@prop.container.not_nil!.name}.#{@prop.name}"
    end

    def self.generate(io : IO, props : Array(PropertyInfo))
      props.each do |prop|
        gen = PropertyWrapperGenerator.new(prop)
        gen.generate(io)
      end
    end

    def do_generate(io : IO)
      flags = @prop.flags
      generate_property_setter(io) if flags.writable?
      generate_property_getter(io) if flags.readable?
    end

    private def generate_property_setter(io : IO)
      type = @prop.type_info
      type_name = to_crystal_type(type)
      io << "def " << to_method_name(@prop.name) << "=(value : " << type_name << ") : " << type_name << LF
      unsafe_identifier = "value"
      if type.array?
        unsafe_identifier = "unsafe_value"
        io << "unsafe_value = "
        generate_array_to_unsafe(io, "value", type)
      end
      io << "LibGObject.g_object_set(self, \"" << @prop.name << "\", " << unsafe_identifier << ", Pointer(Void).null)\n"
      io << "value\n"
      io << "end\n"
    end

    private def is_object?(info : TypeInfo) : Bool
      iface = info.interface
      !iface.nil? && !iface.is_a?(EnumInfo)
    end

    private def generate_property_getter(io : IO)
      type_info = @prop.type_info
      is_obj = is_object?(type_info)
      return_type = to_crystal_type(type_info)

      io << "# " << @prop.ownership_transfer << LF
      io << "def " << to_method_name(@prop.name) << " : " << return_type
      io << "?" if is_obj
      io << LF

      prop_type_name = is_obj ? "Pointer(Void)" : to_lib_type(type_info)
      io << "value = uninitialized " << prop_type_name << LF
      io << "LibGObject.g_object_get(self, \"" << @prop.name << "\", pointerof(value), Pointer(Void).null)\n"
      io << convert_to_crystal("value", type_info, @prop.ownership_transfer)
      io << " unless value.null?" if is_obj

      io << "\nend\n"
    end
  end
end
