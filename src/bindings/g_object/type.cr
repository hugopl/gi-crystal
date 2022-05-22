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
