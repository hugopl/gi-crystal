module GObjectIntrospection
  abstract class RegisteredTypeInfo < BaseInfo
    def type_init : String?
      ptr = LibGIRepository.g_registered_type_info_get_type_init(self)
      String.new(ptr) if ptr
    end

    abstract def methods : Array(FunctionInfo)

    def unref_function : String
      raise ArgumentError.new("ref/unref functions only exists for object/interface info.")
    end

    def ref_function : String
      raise ArgumentError.new("ref/unref functions only exists for object/interface info.")
    end
  end
end
