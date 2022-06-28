module GObject
  class ParamSpec
    def initialize(@pointer : Pointer(Void), transfer : GICrystal::Transfer)
      LibGObject.g_param_spec_ref(@pointer) if transfer.none?
    end

    # Returns ParamSpec reference counter.
    def ref_count : UInt32
      to_unsafe.as(Pointer(LibGObject::ParamSpec)).value.ref_count
    end

    def self.g_type : UInt64
      {% raise "GObject::ParamSpec has no GType" %}
    end
  end
end
