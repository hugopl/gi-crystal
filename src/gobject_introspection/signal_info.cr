module GObjectIntrospection
  module SignalInfoContainer
    @signals : Array(SignalInfo)?

    abstract def signals : Array(SignalInfo)

    def signals(get_n_fields : Proc(_, Int32), get_field : Proc(_, Int32, _)) : Array(SignalInfo)
      @signals ||= begin
        n = get_n_fields.call(to_unsafe)
        Array.new(n) do |i|
          ptr = get_field.call(to_unsafe, i)
          SignalInfo.new(ptr)
        end
      end
    end
  end

  class SignalInfo < CallableInfo
  end
end
