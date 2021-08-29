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
