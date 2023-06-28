require "./callable_info"

module GObjectIntrospection
  module FunctionInfoContainer
    @methods : Array(FunctionInfo)?

    abstract def methods : Array(FunctionInfo)

    def methods(get_n_fields : Proc(_, Int32), get_field : Proc(_, Int32, _)) : Array(FunctionInfo)
      @methods ||= begin
        n = get_n_fields.call(to_unsafe)
        Array.new(n) do |i|
          ptr = get_field.call(to_unsafe, i)
          FunctionInfo.new(ptr)
        end
      end
    end
  end

  class FunctionInfo < CallableInfo
    @symbol : String?

    @[Flags]
    enum Flags
      Method
      Constructor
      Getter
      Setter
      VFunc
      Throws
    end

    def symbol
      @symbol ||= String.new(LibGIRepository.g_function_info_get_symbol(self))
    end

    {% for item in Flags.constants %}
    delegate {{ item.underscore.id }}?, to: flags
    {% end %}

    def flags
      Flags.from_value(LibGIRepository.g_function_info_get_flags(self))
    end

    def to_s(io : IO)
      io << symbol
    end
  end
end
