module GObjectIntrospection
  enum Direction
    In    = 0
    Out   = 1
    InOut = 2
  end

  class ArgInfo < BaseInfo
    def direction
      Direction.from_value(LibGIRepository.g_arg_info_get_direction(self))
    end

    def ownership_transfer
      Transfer.from_value(LibGIRepository.g_arg_info_get_ownership_transfer(self))
    end

    def nullable?
      GICrystal.to_bool(LibGIRepository.g_arg_info_may_be_null(self))
    end

    def caller_allocates?
      GICrystal.to_bool(LibGIRepository.g_arg_info_is_caller_allocates(self))
    end

    def optional?
      GICrystal.to_bool(LibGIRepository.g_arg_info_is_optional(self))
    end

    def type_info : TypeInfo
      @type_info ||= TypeInfo.new(LibGIRepository.g_arg_info_get_type(self))
    end
  end
end
