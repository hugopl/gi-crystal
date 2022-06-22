module Generator
  class PropertyGen < Generator
    private getter prop : PropertyInfo

    def initialize(@prop)
      super(@prop.namespace)
    end

    def object
      @prop.container.not_nil!
    end

    def scope
      "#{object.name}\##{prop.name}"
    end

    private def prop_is_object? : Bool
      iface = @prop.type_info.interface
      !iface.nil? && !iface.is_a?(EnumInfo)
    end

    private def prop_type_name
      @prop_type_name ||= begin
        name = to_crystal_type(@prop.type_info, true)
        prop_is_object? ? "#{name}?" : name
      end
    end

    private def c_prop_type_name
      prop_is_object? ? "Pointer(Void)" : to_lib_type(prop.type_info)
    end

    private def prop_getter_method_name : String
      name = to_call(@prop.name)
      @prop.type_info.tag.boolean? ? "#{name}?" : name
    end
  end
end
