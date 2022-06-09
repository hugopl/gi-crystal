module GICrystal
  def gc_collected?(object : GObject::Object) : Bool
    !LibGObject.g_object_get_qdata(object, GC_COLLECTED_QDATA_KEY).null?
  end

  def instance_pointer(object : GObject::Object) : Pointer(Void)
    LibGObject.g_object_get_qdata(object, INSTANCE_QDATA_KEY)
  end

  def finalize_instance(object : GObject::Object)
    LibGObject.g_object_set_qdata(object, INSTANCE_QDATA_KEY, Pointer(Void).null)
    LibGObject.g_object_set_qdata(object, GC_COLLECTED_QDATA_KEY, Pointer(Void).new(0x1))
    LibGObject.g_object_unref(object)
  end

  def finalize_instance(object : GObject::ParamSpec)
    LibGObject.g_param_spec_set_qdata(object, INSTANCE_QDATA_KEY, Pointer(Void).null)
    LibGObject.g_param_spec_set_qdata(object, GC_COLLECTED_QDATA_KEY, Pointer(Void).new(0x1))
    LibGObject.g_param_spec_unref(object)
  end
end
