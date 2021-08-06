module GObjectIntrospection
  module FieldInfoContainer
    @fields : Array(FieldInfo)?

    abstract def fields : Array(FieldInfo)

    def fields(get_n_fields : Proc(_, Int32), get_field : Proc(_, Int32, _)) : Array(FieldInfo)
      @fields ||= begin
        n = get_n_fields.call(to_unsafe)
        Array.new(n) do |i|
          ptr = get_field.call(to_unsafe, i)
          FieldInfo.new(ptr)
        end
      end
    end
  end

  class FieldInfo < BaseInfo
    def type_info : TypeInfo
      TypeInfo.new(LibGIRepository.g_field_info_get_type(self))
    end

    def byteoffset
      LibGIRepository.g_field_info_get_offset(self)
    end
  end
end
