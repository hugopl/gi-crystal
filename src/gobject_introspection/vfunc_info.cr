require "./callable_info"

module GObjectIntrospection
  module VFuncInfoContainer
    @vfuncs : Array(VFuncInfo)?

    abstract def vfuncs : Array(VFuncInfo)

    def vfuncs(get_n_fields : Proc(_, Int32), get_field : Proc(_, Int32, _)) : Array(VFuncInfo)
      @vfuncs ||= begin
        n = get_n_fields.call(to_unsafe)
        Array.new(n) do |i|
          ptr = get_field.call(to_unsafe, i)
          VFuncInfo.new(ptr)
        end
      end
    end
  end

  class VFuncInfo < CallableInfo
    @[Flags]
    enum Flags : UInt32
      MustChainUp
      MustOverride
      MustNotOverride
      Throws
    end

    {% for item in Flags.constants %}
    delegate {{ item.underscore.id }}?, to: flags
    {% end %}

    def flags
      Flags.from_value(LibGIRepository.g_vfunc_info_get_flags(self))
    end
  end
end
