abstract struct Enum
  @@_g_type : UInt64 = 0

  def self.g_type : UInt64
    if LibGLib.g_once_init_enter(pointerof(@@_g_type)) != 0
      {% begin %}
        test_val = uninitialized self
        _raise_invalid_enum_type(test_val.value)

        {% values = @type.constants %}
        enumvals = LibC.malloc(sizeof(LibGObject::EnumValue) * {{values.size + 1}}).as(LibGObject::EnumValue*)
        {% for val, i in values %}
          enum_value = LibGObject::EnumValue.new
          enum_value.value = {{ @type }}::{{ val }}
          enum_value.value_nick = {{ val.stringify }}
          enum_value.value_name = {{ val.stringify }}
          enumvals[{{i}}] = enum_value
        {% end %}
        enum_value = LibGObject::EnumValue.new
        enum_value.value = 0
        enum_value.value_name = Pointer(LibC::Char).null
        enum_value.value_nick = Pointer(LibC::Char).null
        enumvals[{{ values.size }}] = enum_value

        {% type_name = @type.id.gsub(/::/, "-").stringify %}
        {% if @type.annotation(Flags) %}
          g_type = LibGObject.g_flags_register_static({{ type_name }}, enumvals.as(LibGObject::FlagsValue*))
        {% else %}
          g_type = LibGObject.g_enum_register_static({{ type_name }}, enumvals)
        {% end %}
        LibGLib.g_once_init_leave(pointerof(@@_g_type), g_type)
      {% end %}
    end

    @@_g_type
  end

  # :nodoc:
  def self._is_flags_enum? : Bool
    {{ !!@type.annotation(Flags) }}
  end

  # :nodoc:
  def self._raise_invalid_enum_type(i : T) forall T
    {% raise "Enums used with GLib must use Int32 or UInt32 as their datatype, but #{@type} uses #{T}" unless T == Int32 || T == UInt32 %}
  end
end
