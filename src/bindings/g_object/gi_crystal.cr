module GICrystal
  # Return a pointer to the original wrapper for this object.
  def instance_pointer(object : GObject::Object) : Pointer(Void)
    LibGObject.g_object_get_qdata(object, INSTANCE_QDATA_KEY)
  end

  # Finalize this object, called by `GObject::Object#finalize`
  def finalize_instance(object : GObject::Object)
    LibGObject.g_object_set_qdata(object, INSTANCE_QDATA_KEY, Pointer(Void).null)
    LibGObject.g_object_unref(object)
  end

  # Finalize this object, called by `GObject::ParamSpec#finalize`
  def finalize_instance(object : GObject::ParamSpec)
    LibGObject.g_param_spec_set_qdata(object, INSTANCE_QDATA_KEY, Pointer(Void).null)
    LibGObject.g_param_spec_unref(object)
  end
end
