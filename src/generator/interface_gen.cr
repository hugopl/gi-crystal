require "./property_holder"
require "./method_holder"

module Generator
  class InterfaceGen < FileGen
    include WrapperUtil
    include PropertyHolder
    include MethodHolder

    @iface : InterfaceInfo

    def initialize(@iface : InterfaceInfo)
      super(@iface.namespace)
    end

    def filename : String
      "#{@iface.name.underscore}.cr"
    end

    def scope : String
      "#{namespace.name}::#{@iface.name}"
    end

    def object
      @iface
    end

    def type_name
      to_crystal_type(@iface, false)
    end
  end
end
