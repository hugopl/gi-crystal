require "./lib_glib"
require "./lib_gobject"
require "./lib_gobject_introspection"

require "../gi-crystal"

lib LibGIRepository
  fun g_base_info_unref(info : Pointer(LibGIRepository::BaseInfo))
  fun g_base_info_ref(info : Pointer(LibGIRepository::BaseInfo))
  fun g_constant_info_get_value(this : BaseInfo*, argument : Argument*) : Int32
  fun g_constant_info_free_value(this : BaseInfo*, argument : Argument*)
end

require "./repository"
require "./namespace"
require "./base_info"
require "./registered_type_info"
require "./object_info"
require "./function_info"
require "./arg_info"
require "./type_info"
require "./interface_info"
require "./field_info"
require "./enum_info"
require "./struct_info"
require "./union_info"
require "./callback_info"
require "./property_info"
require "./constant_info"
require "./signal_info"
require "./value_info"

module GObjectIntrospection
  enum Transfer
    None
    Container
    Full
  end

  # This object is from GObject, but for simplicit we put it here
  @[Flags]
  enum ParamFlags : UInt32
    None           =          0
    Readable       =          1
    Writable       =          2
    Readwrite      =          3
    Construct      =          4
    ConstructOnly  =          8
    LaxValidation  =         16
    StaticName     =         32
    Private        =         32
    StaticNick     =         64
    StaticBlurb    =        128
    ExplicitNotify = 1073741824
    Deprecated     = 2147483648
  end

  class Error < RuntimeError
  end
end
