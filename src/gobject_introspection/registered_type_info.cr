module GObjectIntrospection
  class RegisteredTypeInfo < BaseInfo
    def type_init : String?
      ptr = LibGIRepository.g_registered_type_info_get_type_init(self)
      String.new(ptr) if ptr
    end
  end
end
