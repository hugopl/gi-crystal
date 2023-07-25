require "./function_info"
require "./property_info"
require "./vfunc_info"

module GObjectIntrospection
  class InterfaceInfo < RegisteredTypeInfo
    include FunctionInfoContainer
    include PropertyInfoContainer
    include SignalInfoContainer
    include VFuncInfoContainer

    @prerequisites : Array(InterfaceInfo)?

    def methods : Array(FunctionInfo)
      methods(->LibGIRepository.g_interface_info_get_n_methods, ->LibGIRepository.g_interface_info_get_method)
    end

    def properties : Array(PropertyInfo)
      properties(->LibGIRepository.g_interface_info_get_n_properties, ->LibGIRepository.g_interface_info_get_property)
    end

    def signals : Array(SignalInfo)
      signals(->LibGIRepository.g_interface_info_get_n_signals, ->LibGIRepository.g_interface_info_get_signal)
    end

    def vfuncs : Array(VFuncInfo)
      vfuncs(->LibGIRepository.g_interface_info_get_n_vfuncs, ->LibGIRepository.g_interface_info_get_vfunc)
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
