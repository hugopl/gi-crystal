lib LibGObject
  # Functions not declared by GObj Introspection

  # We use this function to store the Crystal wrapper pointer in GObjects,
  # So we can re-use the Crystal objects saving some memory allocations.
  fun g_object_set_qdata(object : Void*, quark : UInt32, data : Void*)

  # This is used only tests
  fun g_object_new(type : UInt64, first_property_name : Pointer(LibC::Char), ...) : Void*

  fun g_signal_new(signal_name : LibC::Char*,
                   itype : UInt64,
                   signal_flags : UInt32,
                   class_offset : UInt32,
                   accumulator : Pointer(Void),
                   accu_data : Pointer(Void),
                   c_marshaller : Pointer(Void),
                   return_type : UInt64,
                   n_params : UInt32, ...) : UInt32

  fun g_type_register_static_simple(parent_type : UInt64,
                                    type_name : LibC::Char*,
                                    class_size : UInt32,
                                    class_init : ClassInitFunc,
                                    instance_size : UInt32,
                                    instance_init : InstanceInitFunc,
                                    flags : Int32) : UInt64

  # Param spec ref/unref
  fun g_param_spec_ref_sink(pspec : Void*)
  fun g_param_spec_ref(pspec : Void*)
  fun g_param_spec_unref(pspec : Void*)
  # Old gobject introspection libs return this typo.
  fun g_param_spec_uref = g_param_spec_unref(pspec : Void*)

  # Property related functions
  fun g_object_get(object : Pointer(Void), property_name : Pointer(LibC::Char), ...)
  fun g_object_set(object : Pointer(Void), property_name : Pointer(LibC::Char), ...)
  fun g_object_new_with_properties(object_type : UInt64, n_properties : UInt32,
                                   names : LibC::Char**, values : Value*) : Void*

  # Signal related functions
  fun g_signal_connect_data(instance : Void*,
                            detailed_signal : UInt8*,
                            c_handler : Void*,
                            data : Void*,
                            destroy_data : Void* -> Nil,
                            flags : UInt32) : UInt64
  @[Raises]
  fun g_signal_emit_by_name(instance : Void*, detailed_signal : UInt8*, ...)

  # Null terminated strings GType, used by GValue
  fun g_strv_get_type : UInt64

  fun g_object_add_toggle_ref(object : Void*, notify : (Void*, Void*, Int32 ->), data : Void*)
  fun g_object_remove_toggle_ref(object : Void*, notify : (Void*, Void*, Int32 ->), data : Void*)
end
