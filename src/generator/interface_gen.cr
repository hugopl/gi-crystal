require "./property_holder"
require "./method_holder"
require "./signal_holder"
require "./vfunc_holder"

module Generator
  class InterfaceGen < FileGen
    include WrapperUtil
    include PropertyHolder
    include MethodHolder
    include SignalHolder
    include VFuncHolder

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

    def each_object_method(&)
      @iface.methods.each do |method|
        yield(method)
      end
      # GObjIntrospection move interface class methods to the Interface struct instead of the interface class, so we fix this
      # here
      iface_struct = @iface.iface_struct
      if iface_struct
        iface_struct.methods.each do |method|
          yield(method) if method.flags.none?
        end
      end
    end
  end
end
