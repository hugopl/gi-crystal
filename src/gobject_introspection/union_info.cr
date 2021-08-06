module GObjectIntrospection
  class UnionInfo < RegisteredTypeInfo
    include FieldInfoContainer

    def fields : Array(FieldInfo)
      fields(->LibGIRepository.g_union_info_get_n_fields, ->LibGIRepository.g_union_info_get_field)
    end

    def bytesize
      LibGIRepository.g_union_info_get_size(self)
    end
  end
end
