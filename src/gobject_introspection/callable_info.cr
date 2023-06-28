module GObjectIntrospection
  class CallableInfo < BaseInfo
    @args : Array(ArgInfo)?

    def args? : Bool
      LibGIRepository.g_callable_info_get_n_args(self) > 0
    end

    def args : Array(ArgInfo)
      @args ||= begin
        n = LibGIRepository.g_callable_info_get_n_args(self)
        Array.new(n) do |i|
          ptr = LibGIRepository.g_callable_info_get_arg(self, i)
          ArgInfo.new(ptr)
        end
      end
    end

    def return_type : TypeInfo
      TypeInfo.new(LibGIRepository.g_callable_info_get_return_type(self))
    end

    def may_return_null? : Bool
      GICrystal.to_bool(LibGIRepository.g_callable_info_may_return_null(self))
    end

    def caller_owns
      Transfer.from_value(LibGIRepository.g_callable_info_get_caller_owns(self))
    end

    def to_s(io : IO)
      io << (name? || "?")
    end
  end
end
