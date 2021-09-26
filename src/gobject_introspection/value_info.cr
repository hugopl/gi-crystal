module GObjectIntrospection
  class ValueInfo < BaseInfo
    def value : Int64
      LibGIRepository.g_value_info_get_value(self)
    end
  end
end
