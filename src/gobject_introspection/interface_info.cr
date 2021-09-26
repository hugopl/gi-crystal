require "./function_info"
require "./property_info"

module GObjectIntrospection
  class InterfaceInfo < RegisteredTypeInfo
    include FunctionInfoContainer
    include PropertyInfoContainer

    @prerequisites : Array(InterfaceInfo)?

    def methods : Array(FunctionInfo)
      methods(->LibGIRepository.g_interface_info_get_n_methods, ->LibGIRepository.g_interface_info_get_method)
    end

    def properties : Array(PropertyInfo)
      properties(->LibGIRepository.g_interface_info_get_n_properties, ->LibGIRepository.g_interface_info_get_property)
    end

    def prerequisites : Array(InterfaceInfo)
      @prerequisites ||= begin
        n = LibGIRepository.g_interface_info_get_n_prerequisites(self)
        Array.new(n) do |i|
          ptr = LibGIRepository.g_interface_info_get_prerequisite(self, i)
          InterfaceInfo.new(ptr)
        end
      end
    end

    def iface_struct : StructInfo?
      ptr = LibGIRepository.g_interface_info_get_iface_struct(self)
      StructInfo.new(ptr) if ptr
    end
  end
end
