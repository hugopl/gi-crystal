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

    def g_error?
      name == "Error" && namespace.name == "GLib"
    end

    def boxed?
      bytesize.zero? && !type_init.nil?
    end

    def pod_type? : Bool
      fields.each do |field|
        type_info = field.type_info
        tag = type_info.tag
        return false if type_info.pointer?

        is_pod = if (tag.boolean? || tag.int8? || tag.u_int8? || tag.int16? || tag.u_int16? || tag.int32? || tag.u_int32? ||
                    tag.int64? || tag.u_int64? || tag.float? || tag.double? || tag.gtype? || tag.unichar?)
                   true
                 elsif tag.interface?
                   iface = type_info.interface.not_nil!
                   iface.is_a?(StructInfo) && iface.pod_type?
                 elsif tag.array? && type_info.array_type.c? && type_info.array_fixed_size > 0
                   true
                 else
                   false
                 end
        return false unless is_pod
      end
      true
    end

    def g_type_struct?
      GICrystal.to_bool(LibGIRepository.g_struct_info_is_gtype_struct(self))
    end
  end
end
