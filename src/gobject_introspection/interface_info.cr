module GObjectIntrospection
  class InterfaceInfo < RegisteredTypeInfo
    include FunctionInfoContainer

    def methods : Array(FunctionInfo)
      methods(->LibGIRepository.g_interface_info_get_n_methods, ->LibGIRepository.g_interface_info_get_method)
    end
  end
end
