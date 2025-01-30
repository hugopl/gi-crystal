module GObjectIntrospection
  class Namespace
    @pointer : Pointer(LibGIRepository::Repository)

    getter name : String
    getter version : String

    getter objects = Array(ObjectInfo).new
    getter flags = Array(EnumInfo).new
    getter structs = Array(StructInfo).new
    getter unions = Array(UnionInfo).new
    getter enums = Array(EnumInfo).new
    getter interfaces = Array(InterfaceInfo).new
    getter functions = Array(FunctionInfo).new
    getter constants = Array(ConstantInfo).new
    getter callbacks = Array(CallbackInfo).new

    @declared_callbacks = Set(String).new

    protected def initialize(@name, version : String? = nil)
      @pointer = LibGIRepository.g_irepository_get_default
      error = Pointer(LibGLib::Error).null
      version_ptr = version ? version.to_unsafe : Pointer(UInt8).null
      ptr = LibGIRepository.g_irepository_require(@pointer, @name, version_ptr, 0, pointerof(error))
      raise Error.new(String.new(error.value.message)) if ptr.null?

      @version = String.new(LibGIRepository.g_irepository_get_version(@pointer, @name))
      load
    end

    def methods
      functions
    end

    def shared_libraries : Array(String)
      ptr = LibGIRepository.g_irepository_get_shared_library(@pointer, @name)
      return [] of String if ptr.null?

      String.new(ptr).split(',')
    end

    def immediate_dependencies : Array(String)
      ptr = LibGIRepository.g_irepository_get_immediate_dependencies(@pointer, @name)
      GICrystal.transfer_null_ended_array(ptr, :full)
    end

    def dependencies : Array(String)
      ptr = LibGIRepository.g_irepository_get_dependencies(@pointer, @name)
      GICrystal.transfer_null_ended_array(ptr, :full)
    end

    # Some callbacks are not declared as new types, like the the ones in GLib IOFunc struct.
    def has_declared_callback?(callback_name : String) : Bool
      @declared_callbacks.includes?(callback_name)
    end

    private def load
      n = LibGIRepository.g_irepository_get_n_infos(@pointer, @name)
      n.times do |i|
        info_ptr = LibGIRepository.g_irepository_get_info(@pointer, @name, i)
        type = BaseInfo::InfoType.from_value(LibGIRepository.g_base_info_get_type(info_ptr))

        case type
        in .object?
          @objects << ObjectInfo.new(info_ptr)
        in .flags?
          @flags << EnumInfo.new(info_ptr)
        in .struct?
          @structs << StructInfo.new(info_ptr)
        in .union?
          @unions << UnionInfo.new(info_ptr)
        in .enum?
          @enums << EnumInfo.new(info_ptr)
        in .interface?
          @interfaces << InterfaceInfo.new(info_ptr)
        in .constant?
          @constants << ConstantInfo.new(info_ptr)
        in .callback?
          callback = CallbackInfo.new(info_ptr)
          @declared_callbacks << callback.name
          @callbacks << callback
        in .boxed?
          Log.warn { "Boxed not working for enums" }
        in .function?
          @functions << FunctionInfo.new(info_ptr)
        in .signal?, .property?, .field?, .arg?, .value?, .type?, .v_func?, .boxed?, .unresolved?
          raise Error.new("WTF!?, a #{type} here?")
        end
      end
    end
  end
end
