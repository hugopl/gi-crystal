module GLib
  class Variant
    @ptr : Pointer(Void)

    def initialize(value)
      ptr = case value
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
      initialize(ptr, :none) # we must sink the floating ref.
    end

    def initialize(@ptr, transfer : GICrystal::Transfer)
      LibGLib.g_variant_ref_sink(self) unless transfer.full?
    end

    def finalize
      LibGLib.g_variant_unref(self)
    end

    def classify : VariantClass
      VariantClass.from_value(LibGLib.g_variant_classify(self))
    end

    def raw
      case classify
      when .boolean? then GICrystal.to_bool(LibGLib.g_variant_get_boolean(self))
      when .byte?    then LibGLib.g_variant_get_byte(self)
      when .int16?   then LibGLib.g_variant_get_int16(self)
      when .uint16?  then LibGLib.g_variant_get_uint16(self)
      when .int32?   then LibGLib.g_variant_get_int32(self)
      when .uint32?  then LibGLib.g_variant_get_uint32(self)
      when .int64?   then LibGLib.g_variant_get_int64(self)
      when .uint64?  then LibGLib.g_variant_get_uint64(self)
      when .double?  then LibGLib.g_variant_get_double(self)
      when .string?  then String.new(LibGLib.g_variant_get_string(self, Pointer(UInt64).null))
      when .variant? then Variant.new(LibGLib.g_variant_get_variant(self), :full)
        # These types aren't implemented yet 😥️
        # when .handle?     then LibGLib.g_variant_get_handle(self)
        # when .object_path? then LibGLib.g_variant_get_object_path(self)
        # when .signature?  then LibGLib.g_variant_get_signature(self)
        # when .maybe?      then LibGLib.g_variant_get_maybe(self)
        # when .array?      then LibGLib.g_variant_get_array(self)
        # when .tuple?      then LibGLib.g_variant_get_tuple(self)
        # when .dictentry?  then LibGLib.g_variant_get_dictentry(self)
      else
        raise NotImplementedError.new("Variant for #{classify} not fully implemented, can you help? 😁️")
      end
    end

    {% for name, type in {
                           "u8"      => UInt8,
                           "i16"     => Int16,
                           "u16"     => UInt16,
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
                           "variant" => Variant,
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

    # Parses a GVariant from a text representation.
    def self.parse(text : String) : Variant
      error = Pointer(LibGLib::Error).null
      ptr = LibGLib.g_variant_parse(nil, text, nil, nil, pointerof(error))
      GLib.raise_gerror(error) if error
      Variant.new(ptr, :full)
    end

    # Pretty-prints value in the format understood by `#parse`.
    def to_s(type_annotate : Bool)
      String.build do |io|
        to_s(io, type_annotate)
      end
    end

    # ditto
    def to_s(io : IO, type_annotate : Bool)
      c_str = LibGLib.g_variant_print(self, GICrystal.to_c_bool(type_annotate))
      io.write(::Bytes.new(c_str, LibC.strlen(c_str).to_i))
    ensure
      LibGLib.g_free(c_str) if c_str
    end

    # ditto
    def to_s(io : IO)
      to_s(io, true)
    end

    # Returns true if *other* variant have the same type and value of this variant.
    def ==(other : Variant) : Bool
      GICrystal.to_bool(LibGLib.g_variant_equal(self, other))
    end

    # :nodoc:
    def to_unsafe
      @ptr
    end
  end
end
