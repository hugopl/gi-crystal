require "./field_info"
require "./function_info"
require "./property_info"
require "./signal_info"
require "./vfunc_info"

module GObjectIntrospection
  class ObjectInfo < RegisteredTypeInfo
    include FieldInfoContainer
    include FunctionInfoContainer
    include PropertyInfoContainer
    include SignalInfoContainer
    include VFuncInfoContainer

    @interfaces : Array(InterfaceInfo)?
    @properties : Array(PropertyInfo)?
    @signals : Array(SignalInfo)?

    def parent : ObjectInfo?
      ptr = LibGIRepository.g_object_info_get_parent(self)
      ObjectInfo.new(ptr) if ptr
    end

    # Return true for fundamental types, like GParamSpec, GObject isn't considered
    # a fundamental type by introspection API.
    def fundamental? : Bool
      GICrystal.to_bool(LibGIRepository.g_object_info_get_fundamental(self))
    end

    def final? : Bool
      GICrystal.to_bool(LibGIRepository.g_object_info_get_final(self))
    end

    def qdata_get_func : String
      # ⚠️ Ugly heuristic ahead
      unref_func = LibGIRepository.g_object_info_get_unref_function(self)
      unref_func.null? ? "g_object_get_qdata" : "g_param_spec_get_qdata"
    end

    def qdata_set_func : String
      # ⚠️ Ugly heuristic ahead
      unref_func = LibGIRepository.g_object_info_get_unref_function(self)
      unref_func.null? ? "g_object_set_qdata" : "g_param_spec_set_qdata"
    end

    def class_struct : StructInfo?
      ptr = LibGIRepository.g_object_info_get_class_struct(self)
      StructInfo.new(ptr) if ptr
    end

    def inherits?(c_type_name : String) : Bool
      parent = to_unsafe
      LibGIRepository.g_base_info_ref(parent)

      while !parent.null?
        type_name = LibGIRepository.g_object_info_get_type_name(parent)
        if LibC.strcmp(type_name, c_type_name).zero?
          return true
        else
          new_parent = LibGIRepository.g_object_info_get_parent(parent)
          LibGIRepository.g_base_info_unref(parent)
          parent = new_parent
        end
      end
      false
    ensure
      LibGIRepository.g_base_info_unref(parent) if parent
    end

    def methods : Array(FunctionInfo)
      methods(->LibGIRepository.g_object_info_get_n_methods, ->LibGIRepository.g_object_info_get_method)
    end

    def fields : Array(FieldInfo)
      fields(->LibGIRepository.g_object_info_get_n_fields, ->LibGIRepository.g_object_info_get_field)
    end

    def properties : Array(PropertyInfo)
      properties(->LibGIRepository.g_object_info_get_n_properties, ->LibGIRepository.g_object_info_get_property)
    end

    def signals : Array(SignalInfo)
      signals(->LibGIRepository.g_object_info_get_n_signals, ->LibGIRepository.g_object_info_get_signal)
    end

    def vfuncs : Array(VFuncInfo)
      vfuncs(->LibGIRepository.g_object_info_get_n_vfuncs, ->LibGIRepository.g_object_info_get_vfunc)
    end

    def interfaces : Array(InterfaceInfo)
      @interfaces ||= begin
        n = LibGIRepository.g_object_info_get_n_interfaces(self)
        Array.new(n) do |i|
          ptr = LibGIRepository.g_object_info_get_interface(self, i)
          InterfaceInfo.new(ptr)
        end
      end
    end
  end
end
