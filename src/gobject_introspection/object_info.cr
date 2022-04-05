require "./field_info"
require "./function_info"
require "./property_info"
require "./signal_info"

module GObjectIntrospection
  class ObjectInfo < RegisteredTypeInfo
    include FieldInfoContainer
    include FunctionInfoContainer
    include PropertyInfoContainer
    include SignalInfoContainer

    @interfaces : Array(InterfaceInfo)?
    @properties : Array(PropertyInfo)?
    @signals : Array(SignalInfo)?

    def parent : ObjectInfo?
      ptr = LibGIRepository.g_object_info_get_parent(self)
      ObjectInfo.new(ptr) if ptr
    end

    def unref_function : String
      func = LibGIRepository.g_object_info_get_unref_function(self)
      func.null? ? "g_object_unref" : String.new(func)
    end

    def ref_function : String
      func = LibGIRepository.g_object_info_get_ref_function(self)
      func.null? ? "g_object_ref" : String.new(func)
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

    def signals : Array(SignalInfo)
      signals(->LibGIRepository.g_object_info_get_n_signals, ->LibGIRepository.g_object_info_get_signal)
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
  end
end
