module GObject
  class Value
    @g_value = LibGObject::Value.new

    # Creates an unitialized GValue.
    def initialize
    end

    # Creates a GValue and initializes it with `value`.
    def initialize(value)
      Value.init_g_value(pointerof(@g_value), value)
    end

    # :nodoc:
    def initialize(ptr : Pointer(Void), transfer : GICrystal::Transfer)
      value_g_type = ptr.as(Pointer(LibGObject::Value)).value.g_type
      LibGObject.g_value_init(self, value_g_type)
      LibGObject.g_value_copy(ptr, self)
      LibGObject.g_value_unset(ptr) if transfer.full?
    end

    # :nodoc:
    def self.init_g_value(ptr : Pointer(LibGObject::Value), value) : Nil
      LibGObject.g_value_init(ptr, Value.g_type_for(value))
      self.set_g_value(ptr, value)
    end

    # :nodoc:
    def self.set_g_value(ptr : Pointer(LibGObject::Value), value) : Nil
      case value
      when Bool          then LibGObject.g_value_set_boolean(ptr, value)
      when Float32       then LibGObject.g_value_set_float(ptr, value)
      when Float64       then LibGObject.g_value_set_double(ptr, value)
      when Int32         then LibGObject.g_value_set_int(ptr, value)
      when Int64         then LibGObject.g_value_set_int64(ptr, value)
      when Int8          then LibGObject.g_value_set_schar(ptr, value)
      when Object        then LibGObject.g_value_set_object(ptr, value)
      when String        then LibGObject.g_value_set_string(ptr, value)
      when UInt32        then LibGObject.g_value_set_uint(ptr, value)
      when UInt64        then LibGObject.g_value_set_uint64(ptr, value)
      when UInt8         then LibGObject.g_value_set_uchar(ptr, value)
      when GLib::Variant then LibGObject.g_value_set_variant(ptr, value)
      when ParamSpec     then LibGObject.g_value_set_param(ptr, value)
      when Enum
        if value.class._is_flags_enum?
          LibGObject.g_value_set_flags(ptr, value)
        else
          LibGObject.g_value_set_enum(ptr, value)
        end
      when Enumerable(String)
        array = value.map(&.to_unsafe).to_a << Pointer(UInt8).null
        LibGObject.g_value_set_boxed(ptr, array)
      else
        raise ArgumentError.new("Unable to wrap a #{value.class} into a GValue.")
      end
    end

    # Returns the GType for the Crystal variable, if the value can be wrap in a `Value`.
    def self.g_type_for(value)
      case value
      when Bool               then TYPE_BOOL
      when Float32            then TYPE_FLOAT
      when Float64            then TYPE_DOUBLE
      when Int32              then TYPE_INT
      when Int64              then TYPE_INT64
      when Int8               then TYPE_CHAR
      when Object             then TYPE_OBJECT
      when String             then TYPE_STRING
      when UInt32             then TYPE_UINT
      when UInt64             then TYPE_UINT64
      when UInt8              then TYPE_UCHAR
      when Enumerable(String) then TYPE_STRV
      when GLib::Variant      then TYPE_VARIANT
      when ParamSpec          then TYPE_PARAM
      when Enum
        if value.class._is_flags_enum?
          TYPE_FLAGS
        else
          TYPE_ENUM
        end
      else
        raise ArgumentError.new("Unable to wrap a #{value.class} into a GValue, probably not implemented.")
      end
    end

    def finalize
      LibGObject.g_value_unset(self)
    end

    # Returns the GValue GType
    def g_type : UInt64
      @g_value.g_type
    end

    def self.raw(g_type : UInt64, ptr : Void*)
      case g_type
      when TYPE_BOOL    then GICrystal.to_bool(LibGObject.g_value_get_boolean(ptr))
      when TYPE_CHAR    then LibGObject.g_value_get_schar(ptr)
      when TYPE_DOUBLE  then LibGObject.g_value_get_double(ptr)
      when TYPE_FLOAT   then LibGObject.g_value_get_float(ptr)
      when TYPE_INT     then LibGObject.g_value_get_int(ptr)
      when TYPE_INT64   then LibGObject.g_value_get_int64(ptr)
      when TYPE_STRING  then String.new(LibGObject.g_value_get_string(ptr))
      when TYPE_UCHAR   then LibGObject.g_value_get_uchar(ptr)
      when TYPE_UINT    then LibGObject.g_value_get_uint(ptr)
      when TYPE_UINT64  then LibGObject.g_value_get_uint64(ptr)
      when TYPE_VARIANT then GLib::Variant.new(LibGObject.g_value_get_variant(ptr), :none)
      when TYPE_PARAM   then ParamSpec.new(LibGObject.g_value_get_param(ptr), :none)
      when TYPE_ENUM    then LibGObject.g_value_get_enum(ptr)
      when TYPE_FLAGS   then LibGObject.g_value_get_flags(ptr)
      when TYPE_OBJECT
        object_ptr = LibGObject.g_value_get_object(ptr)
        object_ptr.null? ? nil : GObject::Object.new(object_ptr, :none)
      else
        raise ArgumentError.new("Cannot obtain raw value for g_type #{g_type}")
      end
    end

    def raw
      GObject::Value.raw(g_type, to_unsafe)
    end

    {% for name, type in {
                           "i8"         => Int8,
                           "u8"         => UInt8,
                           "i32"        => Int32,
                           "i"          => Int32,
                           "u32"        => UInt32,
                           "u"          => UInt32,
                           "i64"        => Int64,
                           "u64"        => UInt64,
                           "f32"        => Float32,
                           "f"          => Float64,
                           "f64"        => Float64,
                           "bool"       => Bool,
                           "s"          => String,
                           "gobject"    => GObject::Object,
                           "variant"    => GLib::Variant,
                           "param_spec" => GObject::ParamSpec,
                         } %}

       def as_{{name.id}} : {{type}}
         raw.as({{type}})
       end

       def as_{{name.id}}?  : {{type}}?
         raw.as?({{type}})
       rescue ArgumentError
         nil
       end
    {% end %}

    # Compare two GObject::Value objects
    def ==(other : Value) : Bool
      LibC.memcmp(self, other.to_unsafe, sizeof(LibGObject::Value)).zero?
    end

    def to_unsafe
      pointerof(@g_value).as(Pointer(Void))
    end
  end
end
