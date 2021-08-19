module GObject
  # GValue is mapped to a enum with all basic types, however there's not a perfect match between Crystal types and
  # GLib types, e.g. GValue supports boxed types and enums, but in Crystal enums can't be in Unions and we have
  # no way to know all BoxedTypes, maybe with some macro magic we can, but I don't want to spend a lot of time in
  # corner cases when in my not so great GTK experience most of the time you use GValue with strings, booleans and
  # numeric types. So, this RawGValue (when fully implemented) must be used to cover these corner cases.
  #
  # To convert a `RawGValue` back to `Value`, use `.to_raw_value`.
  class RawGValue
    @pointer : Pointer(Void)

    def initialize(value : Bool | Float32 | Float64 | Int32 | Int64 | Int8 | Object | String | UInt32 | UInt64 | UInt8)
      @pointer = init_g_value(value)
      case value
      when Bool    then LibGObject.g_value_set_boolean(self, value)
      when Float32 then LibGObject.g_value_set_float(self, value)
      when Float64 then LibGObject.g_value_set_double(self, value)
      when Int32   then LibGObject.g_value_set_int(self, value)
      when Int64   then LibGObject.g_value_set_int64(self, value)
      when Int8    then LibGObject.g_value_set_schar(self, value)
      when Object  then LibGObject.g_value_set_object(self, value)
      when String  then LibGObject.g_value_set_string(self, value)
      when UInt32  then LibGObject.g_value_set_uint(self, value)
      when UInt64  then LibGObject.g_value_set_uint64(self, value)
      when UInt8   then LibGObject.g_value_set_uchar(self, value)
      else
        raise ArgumentError.new("Unable to wrap a #{value.class} into a GValue.")
      end
    end

    def initialize
      @pointer = Pointer(LibGObject::Value).malloc.as(Pointer(Void))
    end

    private def init_g_value(value) : Pointer(Void)
      type = case value
             when Bool    then TYPE_BOOL
             when Float32 then TYPE_FLOAT
             when Float64 then TYPE_DOUBLE
             when Int32   then TYPE_INT
             when Int64   then TYPE_INT64
             when Int8    then TYPE_CHAR
             when Object  then TYPE_OBJECT
             when String  then TYPE_STRING
             when UInt32  then TYPE_UINT
             when UInt64  then TYPE_UINT64
             when UInt8   then TYPE_UCHAR
             else
               raise ArgumentError.new("Unable to wrap a #{value.class} into a GValue, probably not implemented.")
             end
      g_value_ptr = Pointer(LibGObject::Value).malloc.as(Pointer(Void))
      LibGObject.g_value_init(g_value_ptr, type)
      g_value_ptr
    end

    def initialize(value, type : UInt64)
      initialize
      LibGObject.g_value_init(self, type)
    end

    def finalize
      LibGObject.g_value_unset(self) unless @pointer.null?
    end

    def g_type : UInt64
      @pointer.as(Pointer(LibGObject::Value)).value.g_type
    end

    def to_raw_value : Value
      case g_type
      when TYPE_BOOL then GICrystal.to_bool(LibGObject.g_value_get_boolean(self))
      when TYPE_CHAR then LibGObject.g_value_get_schar(self)
      when TYPE_DOUBLE then LibGObject.g_value_get_double(self)
      when TYPE_FLOAT then LibGObject.g_value_get_float(self)
      when TYPE_INT then LibGObject.g_value_get_int(self)
      when TYPE_INT64 then LibGObject.g_value_get_int64(self)
      when TYPE_OBJECT then GObject::Object.new(LibGObject.g_value_get_object(self), GICrystal::Transfer::None)
      when TYPE_STRING then String.new(LibGObject.g_value_get_string(self))
      when TYPE_UCHAR then LibGObject.g_value_get_uchar(self)
      when TYPE_UINT then LibGObject.g_value_get_uint(self)
      when TYPE_UINT64 then LibGObject.g_value_get_uint64(self)
      else
        self
      end.as(Value)
    end

    def to_g_value
      self
    end

    def to_unsafe : Pointer(Void)
      @pointer
    end
  end

  alias Value = Bool | Float32 | Float64 | Int32 | Int64 | Int8 | Object | String | UInt32 | UInt64 | UInt8 | RawGValue
end

{% for type in %w(Bool Float32 Float64 Int32 Int64 Int8 UInt32 UInt64 UInt8) %}
  struct {{ type.id }}
    def to_g_value : GObject::RawGValue
      GObject::RawGValue.new(self)
    end
  end
{% end %}

{% for type in %w(GObject::Object String) %}
  class {{ type.id }}
    def to_g_value : GObject::RawGValue
      GObject::RawGValue.new(self)
    end
  end
{% end %}
