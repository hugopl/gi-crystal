module GObject
  TYPE_INVALID   =  0x0_u64
  TYPE_NONE      =  0x4_u64
  TYPE_INTERFACE =  0x8_u64
  TYPE_CHAR      =  0xc_u64
  TYPE_UCHAR     = 0x10_u64
  TYPE_BOOL      = 0x14_u64
  TYPE_INT       = 0x18_u64
  TYPE_UINT      = 0x1c_u64
  TYPE_LONG      = 0x20_u64
  TYPE_ULONG     = 0x24_u64
  TYPE_INT64     = 0x28_u64
  TYPE_UINT64    = 0x2c_u64
  TYPE_ENUM      = 0x30_u64
  TYPE_FLAGS     = 0x34_u64
  TYPE_FLOAT     = 0x38_u64
  TYPE_DOUBLE    = 0x3c_u64
  TYPE_STRING    = 0x40_u64
  TYPE_POINTER   = 0x44_u64
  TYPE_BOXED     = 0x48_u64
  TYPE_PARAM     = 0x4c_u64
  TYPE_OBJECT    = 0x50_u64
  TYPE_VARIANT   = 0x54_u64
  TYPE_STRV      = LibGObject.g_strv_get_type

  # :nodoc:
  def self.create_param_spec(klass : String?.class, name, nick, blurb, flags, default : String? = nil) : Void*
    LibGObject.g_param_spec_string(name, nick, blurb, default, flags)
  end

  # :nodoc:
  def self.create_param_spec(klass : Bool.class, name, nick, blurb, flags, default : Bool? = nil) : Void*
    LibGObject.g_param_spec_boolean(name, nick, blurb, default || false, flags)
  end

  # :nodoc:
  def self.create_param_spec(klass : Int8.class, name, nick, blurb, flags, default : Int8? = nil, *, min : Int8 = Int8::MIN, max : Int8 = Int8::MAX) : Void*
    LibGObject.g_param_spec_char(name, nick, blurb, min, max, default || 0_i8, flags)
  end

  # :nodoc:
  def self.create_param_spec(klass : UInt8.class, name, nick, blurb, flags, default : UInt8? = nil, *, min : UInt8 = UInt8::MIN, max : UInt8 = UInt8::MAX) : Void*
    LibGObject.g_param_spec_uchar(name, nick, blurb, min, max, default || 0_u8, flags)
  end

  # :nodoc:
  def self.create_param_spec(klass : Int32.class, name, nick, blurb, flags, default : Int32? = nil, *, min : Int32 = Int32::MIN, max : Int32 = Int32::MAX) : Void*
    LibGObject.g_param_spec_int(name, nick, blurb, min, max, default || 0_i32, flags)
  end

  # :nodoc:
  def self.create_param_spec(klass : UInt32.class, name, nick, blurb, flags, default : UInt32? = nil, *, min : UInt32 = UInt32::MIN, max : UInt32 = UInt32::MAX) : Void*
    LibGObject.g_param_spec_uint(name, nick, blurb, min, max, default || 0_u32, flags)
  end

  # :nodoc:
  def self.create_param_spec(klass : Int64.class, name, nick, blurb, flags, default : Int64? = nil, *, min : Int64 = Int64::MIN, max : Int64 = Int64::MAX) : Void*
    LibGObject.g_param_spec_int64(name, nick, blurb, min, max, default || 0_i64, flags)
  end

  # :nodoc:
  def self.create_param_spec(klass : UInt64.class, name, nick, blurb, flags, default : UInt64? = nil, *, min : UInt64 = UInt64::MIN, max : UInt64 = UInt64::MAX) : Void*
    LibGObject.g_param_spec_uint64(name, nick, blurb, min, max, default || 0_u64, flags)
  end

  # :nodoc:
  def self.create_param_spec(klass : Float32.class, name, nick, blurb, flags, default : Float32? = nil, *, min : Float32 = Float32::MIN, max : Float32 = Float32::MAX) : Void*
    LibGObject.g_param_spec_float(name, nick, blurb, min, max, default || 0_f32, flags)
  end

  # :nodoc:
  def self.create_param_spec(klass : Float64.class, name, nick, blurb, flags, default : Float64? = nil, *, min : Float64 = Float64::MIN, max : Float64 = Float64::MAX) : Void*
    LibGObject.g_param_spec_double(name, nick, blurb, min, max, default || 0_f64, flags)
  end

  # :nodoc:
  def self.create_param_spec(klass : GObject::Object?.class, name, nick, blurb, flags, default : Nil = nil) : Void*
    LibGObject.g_param_spec_object(name, nick, blurb, type_not_nil!(klass).g_type, flags)
  end

  # :nodoc:
  def self.create_param_spec(klass : Enum.class, name, nick, blurb, flags, default : Enum? = nil) : Void*
    if klass._is_flags_enum?
      LibGObject.g_param_spec_flags(name, nick, blurb, klass.g_type, default || 0, flags)
    else
      LibGObject.g_param_spec_enum(name, nick, blurb, klass.g_type, default || 0, flags)
    end
  end

  # :nodoc:
  def self.type_not_nil!(klass : T?.class) : T.class forall T
    T
  end

  # :nodoc:
  def self.type_not_nil!(klass)
    klass
  end
end

class String
  # Returns the GObject GType for String.
  def self.g_type
    GObject::TYPE_STRING
  end
end

struct Bool
  # Returns the GObject GType for Bool.
  def self.g_type
    GObject::TYPE_BOOL
  end
end

struct Int8
  # Returns the GObject GType for Int8.
  def self.g_type
    GObject::TYPE_CHAR
  end
end

struct UInt8
  # Returns the GObject GType for UInt8.
  def self.g_type
    GObject::TYPE_UCHAR
  end
end

struct Int32
  # Returns the GObject GType for Int32.
  def self.g_type
    GObject::TYPE_INT
  end
end

struct UInt32
  # Returns the GObject GType for UInt32.
  def self.g_type
    GObject::TYPE_UINT
  end
end

struct Int64
  # Returns the GObject GType for Int64.
  def self.g_type
    GObject::TYPE_INT64
  end
end

struct UInt64
  # Returns the GObject GType for UInt64.
  def self.g_type
    GObject::TYPE_UINT64
  end
end

struct Float32
  # Returns the GObject GType for Float32.
  def self.g_type
    GObject::TYPE_FLOAT
  end
end

struct Float64
  # Returns the GObject GType for Float64.
  def self.g_type
    GObject::TYPE_DOUBLE
  end
end
