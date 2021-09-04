# Only things needed by gobject-introspection library are here
@[Link("gobject-2.0", pkg_config: "gobject-2.0")]
@[Link("glib-2.0", pkg_config: "glib-2.0")]
lib LibGLib
  struct Error
    domain : UInt32
    code : Int32
    message : Pointer(UInt8)
  end

  fun g_error_get_type : UInt64
  fun g_error_new_literal(domain : UInt32, code : Int32, message : Pointer(UInt8)) : Pointer(LibGLib::Error*)
  fun g_error_copy(this : Error*) : Pointer(LibGLib::Error*)
  fun g_error_free(this : Error*) : Void
  fun g_error_matches(this : Error*, domain : UInt32, code : Int32) : LibC::Int

  struct OptionGroup
    _data : UInt8[0]
  end

  fun g_free(mem : Pointer(Void)) : Void
end
