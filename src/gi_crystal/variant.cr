module GLib
  class Variant
    @ptr : Pointer(Void)

    def initialize(value)
      @ptr = case value
             when Bool               then LibGLib.g_variant_new_boolean(value)
             when Enumerable(String) then LibGLib.g_variant_new_strv(value.map(&.to_unsafe).to_a, value.size)
             when Float32, Float64   then LibGLib.g_variant_new_double(value)
             when Int16              then LibGLib.g_variant_new_int16(value)
             when Int32              then LibGLib.g_variant_new_int32(value)
             when Int64              then LibGLib.g_variant_new_int64(value)
             when String             then LibGLib.g_variant_new_string(value)
             when UInt16             then LibGLib.g_variant_new_uint16(value)
             when UInt32             then LibGLib.g_variant_new_uint32(value)
             when UInt64             then LibGLib.g_variant_new_uint64(value)
             when UInt8              then LibGLib.g_variant_new_byte(value)
             when Variant            then LibGLib.g_variant_new_variant(value)
             else
               raise ArgumentError.new("Unable to wrap a #{value.class} into a GVariant.")
             end
    end

    def finalize
      LibGLib.g_variant_unref(self)
    end

    def raw
      raise NotImplementedError.new # 😁️
    end

    {% for name, type in {
                           "u8"      => UInt8,
                           "i32"     => Int32,
                           "i"       => Int32,
                           "u32"     => UInt32,
                           "u"       => UInt32,
                           "i64"     => Int64,
                           "u64"     => UInt64,
                           "f"       => Float64,
                           "f64"     => Float64,
                           "bool"    => Bool,
                           "s"       => String,
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

    def type_string : String
      String.new(LibGLib.g_variant_get_type_string(self))
    end

    def type : GLib::VariantType
      ptr = LibGLib.g_variant_get_type(self)
      GLib::VariantType.new(ptr, GICrystal::Transfer::None)
    end

    def to_unsafe
      @ptr
    end
  end
end
