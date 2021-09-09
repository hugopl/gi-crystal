require "./function_info"
require "./property_info"

module GObjectIntrospection
  class InterfaceInfo < RegisteredTypeInfo
    include FunctionInfoContainer
    include PropertyInfoContainer

    def methods : Array(FunctionInfo)
      methods(->LibGIRepository.g_interface_info_get_n_methods, ->LibGIRepository.g_interface_info_get_method)
    end

    def properties : Array(PropertyInfo)
      properties(->LibGIRepository.g_interface_info_get_n_properties, ->LibGIRepository.g_interface_info_get_property)
    end
  end
end
