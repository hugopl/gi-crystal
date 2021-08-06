require "./field_info"
require "./function_info"

module GObjectIntrospection
  class ObjectInfo < RegisteredTypeInfo
    include FieldInfoContainer
    include FunctionInfoContainer

    @interfaces : Array(InterfaceInfo)?
    @properties : Array(PropertyInfo)?
    @signals : Array(SignalInfo)?

    def parent : ObjectInfo?
      ptr = LibGIRepository.g_object_info_get_parent(self)
      ObjectInfo.new(ptr) if ptr
    end

    def unref_function
      ptr = LibGIRepository.g_object_info_get_unref_function(self)
      if ptr
        puts String.new(ptr)
        String.new(ptr)
      end
    end

    def methods : Array(FunctionInfo)
      methods(->LibGIRepository.g_object_info_get_n_methods, ->LibGIRepository.g_object_info_get_method)
    end

    def fields : Array(FieldInfo)
      fields(->LibGIRepository.g_object_info_get_n_fields, ->LibGIRepository.g_object_info_get_field)
    end

    def properties : Array(PropertyInfo)
      @properties ||= begin
        n = LibGIRepository.g_object_info_get_n_properties(self)
        Array.new(n) do |i|
          ptr = LibGIRepository.g_object_info_get_property(self, i)
          PropertyInfo.new(ptr)
        end
      end
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
