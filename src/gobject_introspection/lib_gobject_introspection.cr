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
    v_string : Pointer(UInt8)
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

  fun g_base_info_gtype_get_type : UInt64
  fun g_base_info_equal(this : BaseInfo*, info2 : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_base_info_get_attribute(this : BaseInfo*, name : Pointer(UInt8)) : Pointer(UInt8)
  fun g_base_info_get_container(this : BaseInfo*) : Pointer(LibGIRepository::BaseInfo)
  fun g_base_info_get_name(this : BaseInfo*) : Pointer(UInt8)
  fun g_base_info_get_namespace(this : BaseInfo*) : Pointer(UInt8)
  fun g_base_info_get_type(this : BaseInfo*) : LibGIRepository::InfoType
  fun g_base_info_get_typelib(this : BaseInfo*) : Pointer(LibGIRepository::Typelib)
  fun g_base_info_is_deprecated(this : BaseInfo*) : LibC::Int
  fun g_base_info_iterate_attributes(this : BaseInfo*, iterator : LibGIRepository::AttributeIter*, name : Pointer(UInt8)*, value : Pointer(UInt8)*) : LibC::Int
  fun g_irepository_get_type : UInt64
  fun g_irepository_error_quark : UInt32
  fun g_irepository_get_default : Pointer(LibGIRepository::Repository)
  fun g_irepository_get_option_group : Pointer(LibGLib::OptionGroup)
  fun g_irepository_get_search_path : Pointer(Void*)
  fun g_irepository_prepend_library_path(directory : Pointer(UInt8)) : Void
  fun g_irepository_prepend_search_path(directory : Pointer(UInt8)) : Void
  fun g_irepository_enumerate_versions(this : Repository*, namespace_ : Pointer(UInt8)) : Pointer(Void*)
  fun g_irepository_find_by_error_domain(this : Repository*, domain : UInt32) : Pointer(LibGIRepository::BaseInfo)
  fun g_irepository_find_by_gtype(this : Repository*, gtype : UInt64) : Pointer(LibGIRepository::BaseInfo)
  fun g_irepository_find_by_name(this : Repository*, namespace_ : Pointer(UInt8), name : Pointer(UInt8)) : Pointer(LibGIRepository::BaseInfo)
  fun g_irepository_get_c_prefix(this : Repository*, namespace_ : Pointer(UInt8)) : Pointer(UInt8)
  fun g_irepository_get_dependencies(this : Repository*, namespace_ : Pointer(UInt8)) : Pointer(Pointer(UInt8))
  fun g_irepository_get_immediate_dependencies(this : Repository*, namespace_ : Pointer(UInt8)) : Pointer(Pointer(UInt8))
  fun g_irepository_get_info(this : Repository*, namespace_ : Pointer(UInt8), index : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_irepository_get_loaded_namespaces(this : Repository*) : Pointer(Pointer(UInt8))
  fun g_irepository_get_n_infos(this : Repository*, namespace_ : Pointer(UInt8)) : Int32
  fun g_irepository_get_object_gtype_interfaces(this : Repository*, gtype : UInt64, n_interfaces_out : UInt32*, interfaces_out : Pointer(Pointer(LibGIRepository::BaseInfo))*) : Void
  fun g_irepository_get_shared_library(this : Repository*, namespace_ : Pointer(UInt8)) : Pointer(UInt8)
  fun g_irepository_get_typelib_path(this : Repository*, namespace_ : Pointer(UInt8)) : Pointer(UInt8)
  fun g_irepository_get_version(this : Repository*, namespace_ : Pointer(UInt8)) : Pointer(UInt8)
  fun g_irepository_is_registered(this : Repository*, namespace_ : Pointer(UInt8), version : Pointer(UInt8)) : LibC::Int
  fun g_irepository_load_typelib(this : Repository*, typelib : Pointer(LibGIRepository::Typelib), flags : LibGIRepository::RepositoryLoadFlags, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_irepository_require(this : Repository*, namespace_ : Pointer(UInt8), version : Pointer(UInt8), flags : LibGIRepository::RepositoryLoadFlags, error : LibGLib::Error**) : Pointer(LibGIRepository::Typelib)
  fun g_irepository_require_private(this : Repository*, typelib_dir : Pointer(UInt8), namespace_ : Pointer(UInt8), version : Pointer(UInt8), flags : LibGIRepository::RepositoryLoadFlags, error : LibGLib::Error**) : Pointer(LibGIRepository::Typelib)
  fun g_arg_info_get_closure(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_arg_info_get_destroy(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_arg_info_get_direction(info : Pointer(LibGIRepository::BaseInfo)) : LibGIRepository::Direction
  fun g_arg_info_get_ownership_transfer(info : Pointer(LibGIRepository::BaseInfo)) : LibGIRepository::Transfer
  fun g_arg_info_get_scope(info : Pointer(LibGIRepository::BaseInfo)) : LibGIRepository::ScopeType
  fun g_arg_info_get_type(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun g_arg_info_is_caller_allocates(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_arg_info_is_optional(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_arg_info_is_return_value(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_arg_info_is_skip(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_arg_info_load_type(info : Pointer(LibGIRepository::BaseInfo), type : LibGIRepository::BaseInfo*) : Void
  fun g_arg_info_may_be_null(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_callable_info_can_throw_gerror(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_callable_info_get_arg(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_callable_info_get_caller_owns(info : Pointer(LibGIRepository::BaseInfo)) : LibGIRepository::Transfer
  fun g_callable_info_get_instance_ownership_transfer(info : Pointer(LibGIRepository::BaseInfo)) : LibGIRepository::Transfer
  fun g_callable_info_get_n_args(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_callable_info_get_return_attribute(info : Pointer(LibGIRepository::BaseInfo), name : Pointer(UInt8)) : Pointer(UInt8)
  fun g_callable_info_get_return_type(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun g_callable_info_invoke(info : Pointer(LibGIRepository::BaseInfo), function : Pointer(Void), in_args : Pointer(LibGIRepository::Argument), n_in_args : Int32, out_args : Pointer(LibGIRepository::Argument), n_out_args : Int32, return_value : Pointer(LibGIRepository::Argument), is_method : LibC::Int, throws : LibC::Int, error : LibGLib::Error**) : LibC::Int
  fun g_callable_info_is_method(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_callable_info_iterate_return_attributes(info : Pointer(LibGIRepository::BaseInfo), iterator : LibGIRepository::AttributeIter*, name : Pointer(UInt8)*, value : Pointer(UInt8)*) : LibC::Int
  fun g_callable_info_load_arg(info : Pointer(LibGIRepository::BaseInfo), n : Int32, arg : LibGIRepository::BaseInfo*) : Void
  fun g_callable_info_load_return_type(info : Pointer(LibGIRepository::BaseInfo), type : LibGIRepository::BaseInfo*) : Void
  fun g_callable_info_may_return_null(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_callable_info_skip_return(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_constant_info_get_type(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun g_enum_info_get_error_domain(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(UInt8)
  fun g_enum_info_get_method(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_enum_info_get_n_methods(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_enum_info_get_n_values(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_enum_info_get_storage_type(info : Pointer(LibGIRepository::BaseInfo)) : LibGIRepository::TypeTag
  fun g_enum_info_get_value(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_field_info_get_flags(info : Pointer(LibGIRepository::BaseInfo)) : LibGIRepository::FieldInfoFlags
  fun g_field_info_get_offset(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_field_info_get_size(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_field_info_get_type(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun g_function_info_get_flags(info : Pointer(LibGIRepository::BaseInfo)) : LibGIRepository::FunctionInfoFlags
  fun g_function_info_get_property(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun g_function_info_get_symbol(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(UInt8)
  fun g_function_info_get_vfunc(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun gi_get_major_version : UInt32
  fun gi_get_micro_version : UInt32
  fun gi_get_minor_version : UInt32
  fun g_info_new(type : LibGIRepository::InfoType, container : Pointer(LibGIRepository::BaseInfo), typelib : Pointer(LibGIRepository::Typelib), offset : UInt32) : Pointer(LibGIRepository::BaseInfo)
  fun g_info_type_to_string(type : LibGIRepository::InfoType) : Pointer(UInt8)
  fun g_interface_info_find_method(info : Pointer(LibGIRepository::BaseInfo), name : Pointer(UInt8)) : Pointer(LibGIRepository::BaseInfo)
  fun g_interface_info_find_signal(info : Pointer(LibGIRepository::BaseInfo), name : Pointer(UInt8)) : Pointer(LibGIRepository::BaseInfo)
  fun g_interface_info_find_vfunc(info : Pointer(LibGIRepository::BaseInfo), name : Pointer(UInt8)) : Pointer(LibGIRepository::BaseInfo)
  fun g_interface_info_get_constant(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_interface_info_get_iface_struct(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun g_interface_info_get_method(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_interface_info_get_n_constants(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_interface_info_get_n_methods(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_interface_info_get_n_prerequisites(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_interface_info_get_n_properties(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_interface_info_get_n_signals(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_interface_info_get_n_vfuncs(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_interface_info_get_prerequisite(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_interface_info_get_property(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_interface_info_get_signal(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_interface_info_get_vfunc(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_invoke_error_quark : UInt32
  fun g_object_info_find_method(info : Pointer(LibGIRepository::BaseInfo), name : Pointer(UInt8)) : Pointer(LibGIRepository::BaseInfo)
  fun g_object_info_find_method_using_interfaces(info : Pointer(LibGIRepository::BaseInfo), name : Pointer(UInt8), implementor : Pointer(LibGIRepository::BaseInfo)*) : Pointer(LibGIRepository::BaseInfo)
  fun g_object_info_find_signal(info : Pointer(LibGIRepository::BaseInfo), name : Pointer(UInt8)) : Pointer(LibGIRepository::BaseInfo)
  fun g_object_info_find_vfunc(info : Pointer(LibGIRepository::BaseInfo), name : Pointer(UInt8)) : Pointer(LibGIRepository::BaseInfo)
  fun g_object_info_find_vfunc_using_interfaces(info : Pointer(LibGIRepository::BaseInfo), name : Pointer(UInt8), implementor : Pointer(LibGIRepository::BaseInfo)*) : Pointer(LibGIRepository::BaseInfo)
  fun g_object_info_get_abstract(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_object_info_get_class_struct(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun g_object_info_get_constant(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_object_info_get_field(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_object_info_get_fundamental(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_object_info_get_get_value_function(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(UInt8)
  fun g_object_info_get_interface(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_object_info_get_method(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_object_info_get_n_constants(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_object_info_get_n_fields(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_object_info_get_n_interfaces(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_object_info_get_n_methods(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_object_info_get_n_properties(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_object_info_get_n_signals(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_object_info_get_n_vfuncs(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_object_info_get_parent(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun g_object_info_get_property(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_object_info_get_ref_function(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(UInt8)
  fun g_object_info_get_set_value_function(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(UInt8)
  fun g_object_info_get_signal(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_object_info_get_type_init(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(UInt8)
  fun g_object_info_get_type_name(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(UInt8)
  fun g_object_info_get_unref_function(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(UInt8)
  fun g_object_info_get_vfunc(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_property_info_get_flags(info : Pointer(LibGIRepository::BaseInfo)) : LibGObject::ParamFlags
  fun g_property_info_get_ownership_transfer(info : Pointer(LibGIRepository::BaseInfo)) : LibGIRepository::Transfer
  fun g_property_info_get_type(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun g_registered_type_info_get_g_type(info : Pointer(LibGIRepository::BaseInfo)) : UInt64
  fun g_registered_type_info_get_type_init(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(UInt8)
  fun g_registered_type_info_get_type_name(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(UInt8)
  fun g_signal_info_get_class_closure(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun g_signal_info_get_flags(info : Pointer(LibGIRepository::BaseInfo)) : LibGObject::SignalFlags
  fun g_signal_info_true_stops_emit(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_struct_info_find_field(info : Pointer(LibGIRepository::BaseInfo), name : Pointer(UInt8)) : Pointer(LibGIRepository::BaseInfo)
  fun g_struct_info_find_method(info : Pointer(LibGIRepository::BaseInfo), name : Pointer(UInt8)) : Pointer(LibGIRepository::BaseInfo)
  fun g_struct_info_get_alignment(info : Pointer(LibGIRepository::BaseInfo)) : UInt64
  fun g_struct_info_get_field(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_struct_info_get_method(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_struct_info_get_n_fields(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_struct_info_get_n_methods(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_struct_info_get_size(info : Pointer(LibGIRepository::BaseInfo)) : UInt64
  fun g_struct_info_is_foreign(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_struct_info_is_gtype_struct(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_type_info_argument_from_hash_pointer(info : Pointer(LibGIRepository::BaseInfo), hash_pointer : Pointer(Void), arg : Pointer(LibGIRepository::Argument)) : Void
  fun g_type_info_get_array_fixed_size(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_type_info_get_array_length(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_type_info_get_array_type(info : Pointer(LibGIRepository::BaseInfo)) : LibGIRepository::ArrayType
  fun g_type_info_get_interface(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun g_type_info_get_param_type(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_type_info_get_storage_type(info : Pointer(LibGIRepository::BaseInfo)) : LibGIRepository::TypeTag
  fun g_type_info_get_tag(info : Pointer(LibGIRepository::BaseInfo)) : LibGIRepository::TypeTag
  fun g_type_info_hash_pointer_from_argument(info : Pointer(LibGIRepository::BaseInfo), arg : Pointer(LibGIRepository::Argument)) : Pointer(Void)
  fun g_type_info_is_pointer(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_type_info_is_zero_terminated(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_type_tag_to_string(type : LibGIRepository::TypeTag) : Pointer(UInt8)
  fun g_union_info_find_method(info : Pointer(LibGIRepository::BaseInfo), name : Pointer(UInt8)) : Pointer(LibGIRepository::BaseInfo)
  fun g_union_info_get_alignment(info : Pointer(LibGIRepository::BaseInfo)) : UInt64
  fun g_union_info_get_discriminator(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_union_info_get_discriminator_offset(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_union_info_get_discriminator_type(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun g_union_info_get_field(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_union_info_get_method(info : Pointer(LibGIRepository::BaseInfo), n : Int32) : Pointer(LibGIRepository::BaseInfo)
  fun g_union_info_get_n_fields(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_union_info_get_n_methods(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_union_info_get_size(info : Pointer(LibGIRepository::BaseInfo)) : UInt64
  fun g_union_info_is_discriminated(info : Pointer(LibGIRepository::BaseInfo)) : LibC::Int
  fun g_value_info_get_value(info : Pointer(LibGIRepository::BaseInfo)) : Int64
  fun g_vfunc_info_get_address(info : Pointer(LibGIRepository::BaseInfo), implementor_gtype : UInt64, error : LibGLib::Error**) : Pointer(Void)
  fun g_vfunc_info_get_flags(info : Pointer(LibGIRepository::BaseInfo)) : LibGIRepository::VFuncInfoFlags
  fun g_vfunc_info_get_invoker(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
  fun g_vfunc_info_get_offset(info : Pointer(LibGIRepository::BaseInfo)) : Int32
  fun g_vfunc_info_get_signal(info : Pointer(LibGIRepository::BaseInfo)) : Pointer(LibGIRepository::BaseInfo)
end
