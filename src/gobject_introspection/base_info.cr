module GObjectIntrospection
  class BaseInfo
    enum InfoType
      Function   =  1
      Callback   =  2
      Struct     =  3
      Boxed      =  4
      Enum       =  5
      Flags      =  6
      Object     =  7
      Interface  =  8
      Constant   =  9
      Union      = 11
      Value      = 12
      Signal     = 13
      VFunc      = 14
      Property   = 15
      Field      = 16
      Arg        = 17
      Type       = 18
      Unresolved = 19
    end

    @pointer : Pointer(LibGIRepository::BaseInfo)

    # memoization
    @name : String?

    def self.build(ptr : Pointer(LibGIRepository::BaseInfo))
      LibGIRepository.g_base_info_ref(ptr)
      type = InfoType.from_value(LibGIRepository.g_base_info_get_type(ptr))
      case type
      when .function?      then FunctionInfo.new(ptr)
      when .object?        then ObjectInfo.new(ptr)
      when .struct?        then StructInfo.new(ptr)
      when .callback?      then CallbackInfo.new(ptr)
      when .enum?, .flags? then EnumInfo.new(ptr)
      when .union?         then UnionInfo.new(ptr)
      when .interface?     then InterfaceInfo.new(ptr)
      when .unresolved?
        nil
      else
        raise "BaseInfo unknown: #{type}"
      end
    end

    def initialize(@pointer)
      raise ArgumentError.new("Got null pointer for BaseInfo.") unless @pointer
    end

    def finalize
      LibGIRepository.g_base_info_unref(self)
    end

    def to_unsafe
      @pointer
    end

    def name : String
      str = name?
      raise Error.new("#{info_type} has no name.") if str.nil?

      str
    end

    def name? : String?
      @name = begin
        ptr = LibGIRepository.g_base_info_get_name(self)
        String.new(ptr) if ptr
      end
    end

    def namespace : Namespace
      Repository.default.require(String.new(LibGIRepository.g_base_info_get_namespace(self)))
    end

    def deprecated? : Bool
      GICrystal.to_bool(LibGIRepository.g_base_info_is_deprecated(self))
    end

    def info_type : InfoType
      InfoType.from_value(LibGIRepository.g_base_info_get_type(self))
    end

    def container : BaseInfo?
      ptr = LibGIRepository.g_base_info_get_container(self)
      return if ptr.null?

      BaseInfo.build(ptr)
    end
  end
end
