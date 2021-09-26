module GObjectIntrospection
  class UnionInfo < RegisteredTypeInfo
    include FunctionInfoContainer
    include FieldInfoContainer

    def fields : Array(FieldInfo)
      fields(->LibGIRepository.g_union_info_get_n_fields, ->LibGIRepository.g_union_info_get_field)
    end

    def methods : Array(FunctionInfo)
      methods(->LibGIRepository.g_union_info_get_n_methods, ->LibGIRepository.g_union_info_get_method)
    end

    def bytesize
      LibGIRepository.g_union_info_get_size(self)
    end
  end
end
