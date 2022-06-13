module GObject
  class ParamSpec
    # Returns ParamSpec reference counter.
    def ref_count : UInt32
      to_unsafe.as(Pointer(LibGObject::ParamSpec)).value.ref_count
    end

    def self.g_type : UInt64
      {% raise "GObject::ParamSpec has no GType" %}
    end
  end
end
