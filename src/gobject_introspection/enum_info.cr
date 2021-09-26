module GObjectIntrospection
  class EnumInfo < RegisteredTypeInfo
    include FunctionInfoContainer
    @values : Array(ValueInfo)?

    def storage_type : TypeTag
      TypeTag.from_value(LibGIRepository.g_enum_info_get_storage_type(self))
    end

    def values : Array(ValueInfo)
      @values ||= begin
        n = LibGIRepository.g_enum_info_get_n_values(self)
        Array.new(n) do |i|
          ptr = LibGIRepository.g_enum_info_get_value(self, i)
          ValueInfo.new(ptr)
        end
      end
    end

    def methods : Array(FunctionInfo)
      methods(->LibGIRepository.g_enum_info_get_n_methods, ->LibGIRepository.g_enum_info_get_method)
    end
  end
end
