module GObjectIntrospection
  enum TypeTag
    Void      =  0
    Boolean   =  1
    Int8      =  2
    UInt8     =  3
    Int16     =  4
    UInt16    =  5
    Int32     =  6
    UInt32    =  7
    Int64     =  8
    UInt64    =  9
    Float     = 10
    Double    = 11
    Gtype     = 12
    Utf8      = 13
    Filename  = 14
    Array     = 15
    Interface = 16
    GList     = 17
    GSList    = 18
    GHash     = 19
    Error     = 20
    Unichar   = 21
  end

  enum ArrayType
    C
    GArray
    PtrArray
    ByteArray
  end

  class TypeInfo < BaseInfo
    def pointer? : Bool
      GICrystal.to_bool(LibGIRepository.g_type_info_is_pointer(self))
    end

    def tag : TypeTag
      @tag ||= TypeTag.from_value(LibGIRepository.g_type_info_get_tag(self))
    end

    def void?
      tag.void? && !pointer?
    end

    delegate array?, to: tag

    def object? : Bool
      iface = interface
      !iface.nil? && !iface.is_a?(EnumInfo)
    end

    def interface : BaseInfo?
      ptr = LibGIRepository.g_type_info_get_interface(self)
      BaseInfo.build(ptr) if ptr
    end

    def array_type : ArrayType
      ArrayType.from_value(LibGIRepository.g_type_info_get_array_type(self))
    end

    def array_length : Int32
      LibGIRepository.g_type_info_get_array_length(self)
    end

    def array_fixed_size : Int32
      LibGIRepository.g_type_info_get_array_fixed_size(self)
    end

    def array_zero_terminated?
      GICrystal.to_bool(LibGIRepository.g_type_info_is_zero_terminated(self))
    end

    def param_type(n = 0) : TypeInfo
      TypeInfo.new(LibGIRepository.g_type_info_get_param_type(self, n))
    end
  end
end
