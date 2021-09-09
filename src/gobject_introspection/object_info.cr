require "./field_info"
require "./function_info"
require "./property_info"

module GObjectIntrospection
  class ObjectInfo < RegisteredTypeInfo
    include FieldInfoContainer
    include FunctionInfoContainer
    include PropertyInfoContainer

    @interfaces : Array(InterfaceInfo)?
    @properties : Array(PropertyInfo)?
    @signals : Array(SignalInfo)?

    def parent : ObjectInfo?
      ptr = LibGIRepository.g_object_info_get_parent(self)
      ObjectInfo.new(ptr) if ptr
    end

    def methods : Array(FunctionInfo)
      methods(->LibGIRepository.g_object_info_get_n_methods, ->LibGIRepository.g_object_info_get_method)
    end

    def fields : Array(FieldInfo)
      fields(->LibGIRepository.g_object_info_get_n_fields, ->LibGIRepository.g_object_info_get_field)
    end

    def properties : Array(PropertyInfo)
      properties(->LibGIRepository.g_object_info_get_n_properties, ->LibGIRepository.g_object_info_get_property)
    end

    def interfaces : Array(InterfaceInfo)
      @interfaces ||= begin
        n = LibGIRepository.g_object_info_get_n_interfaces(self)
        Array.new(n) do |i|
          ptr = LibGIRepository.g_object_info_get_interface(self, i)
          InterfaceInfo.new(ptr)
        end
      end
    end

    def signals : Array(SignalInfo)
      @signals ||= begin
        n = LibGIRepository.g_object_info_get_n_signals(self)
        Array.new(n) do |i|
          ptr = LibGIRepository.g_object_info_get_signal(self, i)
          SignalInfo.new(ptr)
        end
      end
    end
  end
end
