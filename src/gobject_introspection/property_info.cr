module GObjectIntrospection
  module PropertyInfoContainer
    @properties : Array(PropertyInfo)?

    abstract def methods : Array(FunctionInfo)

    def properties(get_n_fields : Proc(_, Int32), get_field : Proc(_, Int32, _)) : Array(PropertyInfo)
      @properties ||= begin
        n = get_n_fields.call(to_unsafe)
        Array.new(n) do |i|
          ptr = get_field.call(to_unsafe, i)
          PropertyInfo.new(ptr)
        end
      end
    end
  end

  class PropertyInfo < BaseInfo
    def type_info : TypeInfo
      @type_info ||= TypeInfo.new(LibGIRepository.g_property_info_get_type(self))
    end

    def ownership_transfer
      Transfer.from_value(LibGIRepository.g_property_info_get_ownership_transfer(self))
    end

    def flags : ParamFlags
      ParamFlags.from_value(LibGIRepository.g_property_info_get_flags(self))
    end
  end
end
