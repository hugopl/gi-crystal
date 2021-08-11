module GObjectIntrospection
  class StructInfo < RegisteredTypeInfo
    include FieldInfoContainer
    include FunctionInfoContainer

    def fields : Array(FieldInfo)
      fields(->LibGIRepository.g_struct_info_get_n_fields, ->LibGIRepository.g_struct_info_get_field)
    end

    def methods : Array(FunctionInfo)
      methods(->LibGIRepository.g_struct_info_get_n_methods, ->LibGIRepository.g_struct_info_get_method)
    end

    def bytesize
      LibGIRepository.g_struct_info_get_size(self)
    end

    def copyable?
      bytesize > 0
    end

    def boxed?
      bytesize.zero? && !type_init.nil?
    end

    def gtype_struct?
      GICrystal.to_bool(LibGIRepository.g_struct_info_is_gtype_struct(self))
    end
  end
end
