module GObjectIntrospection
  class PropertyInfo < BaseInfo
    def type_info : TypeInfo
      @type_info ||= TypeInfo.new(LibGIRepository.g_property_info_get_type(self))
    end

    def ownership_transfer
      GICrystal::Transfer.from_value(LibGIRepository.g_property_info_get_ownership_transfer(self))
    end

    def flags : ParamFlags
      ParamFlags.from_value(LibGIRepository.g_property_info_get_flags(self))
    end
  end
end
