require "./lib_gobject"

@[Link("girepository-1.0", pkg_config: "gobject-introspection-1.0")]
lib LibGIRepository
  union Argument
    v_boolean : LibC::Int
    v_int8 : Int8
    v_uint8 : UInt8
    v_int16 : Int16
    v_uint16 : UInt16
    v_int32 : Int32
    v_uint32 : UInt32
    v_int64 : Int64
    v_uint64 : UInt64
    v_float : Float32
    v_double : Float64
    v_short : Int16
    v_ushort : UInt16
    v_int : Int32
    v_uint : UInt32
    v_long : Int64
    v_ulong : UInt64
    v_ssize : Int64
    v_size : UInt64
    v_string : UInt8*
    v_pointer : Pointer(Void)
  end

  # Enums
  alias ArrayType = UInt32
  alias Direction = UInt32
  alias InfoType = UInt32
  alias RepositoryError = UInt32
  alias ScopeType = UInt32
  alias Transfer = UInt32
  alias TypeTag = UInt32

  # Structs
  type AttributeIter = Void
  type BaseInfo = Void
  type Typelib = Void
  type Repository = Void

  # Flags
  alias FieldInfoFlags = UInt32
  alias FunctionInfoFlags = UInt32
  alias RepositoryLoadFlags = UInt32
  alias VFuncInfoFlags = UInt32

  fun g_arg_info_get_closure(info : BaseInfo*) : Int32
  fun g_arg_info_get_destroy(info : BaseInfo*) : Int32
  fun g_arg_info_get_direction(info : BaseInfo*) : Direction
  fun g_arg_info_get_ownership_transfer(info : BaseInfo*) : Transfer
  fun g_arg_info_get_scope(info : BaseInfo*) : ScopeType
  fun g_arg_info_get_type(info : BaseInfo*) : BaseInfo*
  fun g_arg_info_is_caller_allocates(info : BaseInfo*) : LibC::Int
  fun g_arg_info_is_optional(info : BaseInfo*) : LibC::Int
  fun g_arg_info_is_return_value(info : BaseInfo*) : LibC::Int
  fun g_arg_info_is_skip(info : BaseInfo*) : LibC::Int
  fun g_arg_info_load_type(info : BaseInfo*, type : BaseInfo*) : Void
  fun g_arg_info_may_be_null(info : BaseInfo*) : LibC::Int
  fun g_base_info_equal(this : BaseInfo*, info2 : BaseInfo*) : LibC::Int
  fun g_base_info_get_attribute(this : BaseInfo*, name : UInt8*) : UInt8*
  fun g_base_info_get_container(this : BaseInfo*) : BaseInfo*
  fun g_base_info_get_namespace(this : BaseInfo*) : UInt8*
  fun g_base_info_get_name(this : BaseInfo*) : UInt8*
  fun g_base_info_get_typelib(this : BaseInfo*) : Typelib*
  fun g_base_info_get_type(this : BaseInfo*) : InfoType
  fun g_base_info_gtype_get_type : UInt64
  fun g_base_info_is_deprecated(this : BaseInfo*) : LibC::Int
  fun g_base_info_iterate_attributes(this : BaseInfo*, iterator : AttributeIter*, name : UInt8**, value : UInt8**) : LibC::Int
  fun g_callable_info_can_throw_gerror(info : BaseInfo*) : LibC::Int
  fun g_callable_info_get_arg(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_callable_info_get_caller_owns(info : BaseInfo*) : Transfer
  fun g_callable_info_get_instance_ownership_transfer(info : BaseInfo*) : Transfer
  fun g_callable_info_get_n_args(info : BaseInfo*) : Int32
  fun g_callable_info_get_return_attribute(info : BaseInfo*, name : UInt8*) : UInt8*
  fun g_callable_info_get_return_type(info : BaseInfo*) : BaseInfo*
  fun g_callable_info_is_method(info : BaseInfo*) : LibC::Int
  fun g_callable_info_iterate_return_attributes(info : BaseInfo*, iterator : AttributeIter*, name : UInt8**, value : UInt8**) : LibC::Int
  fun g_callable_info_load_arg(info : BaseInfo*, n : Int32, arg : BaseInfo*) : Void
  fun g_callable_info_load_return_type(info : BaseInfo*, type : BaseInfo*) : Void
  fun g_callable_info_may_return_null(info : BaseInfo*) : LibC::Int
  fun g_callable_info_skip_return(info : BaseInfo*) : LibC::Int
  fun g_constant_info_get_type(info : BaseInfo*) : BaseInfo*
  fun g_enum_info_get_error_domain(info : BaseInfo*) : UInt8*
  fun g_enum_info_get_method(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_enum_info_get_n_methods(info : BaseInfo*) : Int32
  fun g_enum_info_get_n_values(info : BaseInfo*) : Int32
  fun g_enum_info_get_storage_type(info : BaseInfo*) : TypeTag
  fun g_enum_info_get_value(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_field_info_get_flags(info : BaseInfo*) : FieldInfoFlags
  fun g_field_info_get_offset(info : BaseInfo*) : Int32
  fun g_field_info_get_size(info : BaseInfo*) : Int32
  fun g_field_info_get_type(info : BaseInfo*) : BaseInfo*
  fun g_function_info_get_flags(info : BaseInfo*) : FunctionInfoFlags
  fun g_function_info_get_property(info : BaseInfo*) : BaseInfo*
  fun g_function_info_get_symbol(info : BaseInfo*) : UInt8*
  fun g_function_info_get_vfunc(info : BaseInfo*) : BaseInfo*
  fun gi_get_major_version : UInt32
  fun gi_get_micro_version : UInt32
  fun gi_get_minor_version : UInt32
  fun g_info_new(type : InfoType, container : BaseInfo*, typelib : Pointer(Typelib), offset : UInt32) : BaseInfo*
  fun g_info_type_to_string(type : InfoType) : UInt8*
  fun g_interface_info_find_method(info : BaseInfo*, name : UInt8*) : BaseInfo*
  fun g_interface_info_find_signal(info : BaseInfo*, name : UInt8*) : BaseInfo*
  fun g_interface_info_find_vfunc(info : BaseInfo*, name : UInt8*) : BaseInfo*
  fun g_interface_info_get_constant(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_interface_info_get_iface_struct(info : BaseInfo*) : BaseInfo*
  fun g_interface_info_get_method(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_interface_info_get_n_constants(info : BaseInfo*) : Int32
  fun g_interface_info_get_n_methods(info : BaseInfo*) : Int32
  fun g_interface_info_get_n_prerequisites(info : BaseInfo*) : Int32
  fun g_interface_info_get_n_properties(info : BaseInfo*) : Int32
  fun g_interface_info_get_n_signals(info : BaseInfo*) : Int32
  fun g_interface_info_get_n_vfuncs(info : BaseInfo*) : Int32
  fun g_interface_info_get_prerequisite(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_interface_info_get_property(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_interface_info_get_signal(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_interface_info_get_vfunc(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_invoke_error_quark : UInt32
  fun g_irepository_enumerate_versions(this : Repository*, namespace_ : UInt8*) : Void*
  fun g_irepository_error_quark : UInt32
  fun g_irepository_find_by_error_domain(this : Repository*, domain : UInt32) : BaseInfo*
  fun g_irepository_find_by_gtype(this : Repository*, gtype : UInt64) : BaseInfo*
  fun g_irepository_find_by_name(this : Repository*, namespace_ : UInt8*, name : UInt8*) : BaseInfo*
  fun g_irepository_get_c_prefix(this : Repository*, namespace_ : UInt8*) : UInt8*
  fun g_irepository_get_default : Repository*
  fun g_irepository_get_dependencies(this : Repository*, namespace_ : UInt8*) : UInt8**
  fun g_irepository_get_immediate_dependencies(this : Repository*, namespace_ : UInt8*) : UInt8**
  fun g_irepository_get_info(this : Repository*, namespace_ : UInt8*, index : Int32) : BaseInfo*
  fun g_irepository_get_loaded_namespaces(this : Repository*) : UInt8**
  fun g_irepository_get_n_infos(this : Repository*, namespace_ : UInt8*) : Int32
  fun g_irepository_get_object_gtype_interfaces(this : Repository*, gtype : UInt64, n_interfaces_out : UInt32*, interfaces_out : BaseInfo***) : Void
  fun g_irepository_get_option_group : LibGLib::OptionGroup*
  fun g_irepository_get_search_path : Void*
  fun g_irepository_get_shared_library(this : Repository*, namespace_ : UInt8*) : UInt8*
  fun g_irepository_get_typelib_path(this : Repository*, namespace_ : UInt8*) : UInt8*
  fun g_irepository_get_type : UInt64
  fun g_irepository_get_version(this : Repository*, namespace_ : UInt8*) : UInt8*
  fun g_irepository_is_registered(this : Repository*, namespace_ : UInt8*, version : UInt8*) : LibC::Int
  fun g_irepository_load_typelib(this : Repository*, typelib : Typelib*, flags : RepositoryLoadFlags, error : LibGLib::Error**) : UInt8*
  fun g_irepository_prepend_library_path(directory : UInt8*) : Void
  fun g_irepository_prepend_search_path(directory : UInt8*) : Void
  fun g_irepository_require_private(this : Repository*, typelib_dir : UInt8*, namespace_ : UInt8*, version : UInt8*, flags : RepositoryLoadFlags, error : LibGLib::Error**) : Typelib*
  fun g_irepository_require(this : Repository*, namespace_ : UInt8*, version : UInt8*, flags : RepositoryLoadFlags, error : LibGLib::Error**) : Typelib*
  fun g_object_info_find_method(info : BaseInfo*, name : UInt8*) : BaseInfo*
  fun g_object_info_find_method_using_interfaces(info : BaseInfo*, name : UInt8*, implementor : BaseInfo**) : BaseInfo*
  fun g_object_info_find_signal(info : BaseInfo*, name : UInt8*) : BaseInfo*
  fun g_object_info_find_vfunc(info : BaseInfo*, name : UInt8*) : BaseInfo*
  fun g_object_info_find_vfunc_using_interfaces(info : BaseInfo*, name : UInt8*, implementor : BaseInfo**) : BaseInfo*
  fun g_object_info_get_abstract(info : BaseInfo*) : LibC::Int
  fun g_object_info_get_class_struct(info : BaseInfo*) : BaseInfo*
  fun g_object_info_get_constant(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_object_info_get_field(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_object_info_get_final(info : BaseInfo*) : LibC::Int
  fun g_object_info_get_fundamental(info : BaseInfo*) : LibC::Int
  fun g_object_info_get_get_value_function(info : BaseInfo*) : UInt8*
  fun g_object_info_get_interface(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_object_info_get_method(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_object_info_get_n_constants(info : BaseInfo*) : Int32
  fun g_object_info_get_n_fields(info : BaseInfo*) : Int32
  fun g_object_info_get_n_interfaces(info : BaseInfo*) : Int32
  fun g_object_info_get_n_methods(info : BaseInfo*) : Int32
  fun g_object_info_get_n_properties(info : BaseInfo*) : Int32
  fun g_object_info_get_n_signals(info : BaseInfo*) : Int32
  fun g_object_info_get_n_vfuncs(info : BaseInfo*) : Int32
  fun g_object_info_get_parent(info : BaseInfo*) : BaseInfo*
  fun g_object_info_get_property(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_object_info_get_ref_function(info : BaseInfo*) : UInt8*
  fun g_object_info_get_set_value_function(info : BaseInfo*) : UInt8*
  fun g_object_info_get_signal(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_object_info_get_type_init(info : BaseInfo*) : UInt8*
  fun g_object_info_get_type_name(info : BaseInfo*) : UInt8*
  fun g_object_info_get_unref_function(info : BaseInfo*) : UInt8*
  fun g_object_info_get_vfunc(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_property_info_get_flags(info : BaseInfo*) : LibGObject::ParamFlags
  fun g_property_info_get_ownership_transfer(info : BaseInfo*) : Transfer
  fun g_property_info_get_type(info : BaseInfo*) : BaseInfo*
  fun g_registered_type_info_get_g_type(info : BaseInfo*) : UInt64
  fun g_registered_type_info_get_type_init(info : BaseInfo*) : UInt8*
  fun g_registered_type_info_get_type_name(info : BaseInfo*) : UInt8*
  fun g_signal_info_get_class_closure(info : BaseInfo*) : BaseInfo*
  fun g_signal_info_get_flags(info : BaseInfo*) : LibGObject::SignalFlags
  fun g_signal_info_true_stops_emit(info : BaseInfo*) : LibC::Int
  fun g_struct_info_find_field(info : BaseInfo*, name : UInt8*) : BaseInfo*
  fun g_struct_info_find_method(info : BaseInfo*, name : UInt8*) : BaseInfo*
  fun g_struct_info_get_alignment(info : BaseInfo*) : UInt64
  fun g_struct_info_get_field(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_struct_info_get_method(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_struct_info_get_n_fields(info : BaseInfo*) : Int32
  fun g_struct_info_get_n_methods(info : BaseInfo*) : Int32
  fun g_struct_info_get_size(info : BaseInfo*) : UInt64
  fun g_struct_info_is_foreign(info : BaseInfo*) : LibC::Int
  fun g_struct_info_is_gtype_struct(info : BaseInfo*) : LibC::Int
  fun g_type_info_argument_from_hash_pointer(info : BaseInfo*, hash_pointer : Pointer(Void), arg : Pointer(Argument)) : Void
  fun g_type_info_get_array_fixed_size(info : BaseInfo*) : Int32
  fun g_type_info_get_array_length(info : BaseInfo*) : Int32
  fun g_type_info_get_array_type(info : BaseInfo*) : ArrayType
  fun g_type_info_get_interface(info : BaseInfo*) : BaseInfo*
  fun g_type_info_get_param_type(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_type_info_get_storage_type(info : BaseInfo*) : TypeTag
  fun g_type_info_get_tag(info : BaseInfo*) : TypeTag
  fun g_type_info_hash_pointer_from_argument(info : BaseInfo*, arg : Pointer(Argument)) : Pointer(Void)
  fun g_type_info_is_pointer(info : BaseInfo*) : LibC::Int
  fun g_type_info_is_zero_terminated(info : BaseInfo*) : LibC::Int
  fun g_type_tag_to_string(type : TypeTag) : UInt8*
  fun g_union_info_find_method(info : BaseInfo*, name : UInt8*) : BaseInfo*
  fun g_union_info_get_alignment(info : BaseInfo*) : UInt64
  fun g_union_info_get_discriminator(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_union_info_get_discriminator_offset(info : BaseInfo*) : Int32
  fun g_union_info_get_discriminator_type(info : BaseInfo*) : BaseInfo*
  fun g_union_info_get_field(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_union_info_get_method(info : BaseInfo*, n : Int32) : BaseInfo*
  fun g_union_info_get_n_fields(info : BaseInfo*) : Int32
  fun g_union_info_get_n_methods(info : BaseInfo*) : Int32
  fun g_union_info_get_size(info : BaseInfo*) : UInt64
  fun g_union_info_is_discriminated(info : BaseInfo*) : LibC::Int
  fun g_value_info_get_value(info : BaseInfo*) : Int64
  fun g_vfunc_info_get_address(info : BaseInfo*, implementor_gtype : UInt64, error : LibGLib::Error**) : Pointer(Void)
  fun g_vfunc_info_get_flags(info : BaseInfo*) : VFuncInfoFlags
  fun g_vfunc_info_get_invoker(info : BaseInfo*) : BaseInfo*
  fun g_vfunc_info_get_offset(info : BaseInfo*) : Int32
  fun g_vfunc_info_get_signal(info : BaseInfo*) : BaseInfo*
end
