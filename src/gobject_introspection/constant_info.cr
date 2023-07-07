module GObjectIntrospection
  class ConstantInfo < BaseInfo
    def type_info
      ptr = LibGIRepository.g_constant_info_get_type(self)
      TypeInfo.new(ptr)
    end

    def literal : String
      value = uninitialized LibGIRepository::Argument
      LibGIRepository.g_constant_info_get_value(self, pointerof(value))

      tag = type_info.tag
      case tag
      when .boolean?
        value.v_boolean == 1 ? "true" : "false"
      when .int8?
        "#{value.v_int8}_i8"
      when .u_int8?
        "#{value.v_uint8}_u8"
      when .int16?
        "#{value.v_int16}_i16"
      when .u_int16?
        "#{value.v_uint16}_u16"
      when .int32?
        value.v_int32.to_s
      when .u_int32?
        "#{value.v_uint32}_u32"
      when .int64?
        "#{value.v_int64}_i64"
      when .u_int64?
        "#{value.v_uint64}_u64"
      when .float?
        "#{value.v_float}_f32"
      when .double?
        value.v_double.to_s
      when .utf8?
        String.new(value.v_string).inspect
        # Not supported ones
      when .interface?
        Log.warn { "#{tag} constant not supported." }
        "0 # Interface constants not supported!"
      else
        raise Error.new("Unknow literal representation for #{tag}")
      end.tap do
        # This must be in a ensure block, but a compiler bug is triggered if we do this.
        LibGIRepository.g_constant_info_free_value(self, pointerof(value))
      end
    end
  end
end
