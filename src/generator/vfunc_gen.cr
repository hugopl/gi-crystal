require "./arg_strategy"
require "./callable_gen"
require "./box_helper"

module Generator
  class VFuncGen < CallableGen
    include BoxHelper
    include Helpers

    alias MethodReturnType = TypeInfo | ArgInfo

    private getter vfunc : VFuncInfo
    getter object : InterfaceInfo | ObjectInfo
    @byte_offset : Int32?

    def initialize(@object, @vfunc)
      super(@vfunc.namespace)
      @byte_offset = byte_offset
    end

    def skip? : Bool
      vfunc.must_not_override? || !@byte_offset
    end

    private def write_implementations(io)
      args_strategies = ArgStrategy.find_strategies(vfunc, :c_to_crystal)
      args_strategies.each do |arg_strategy|
        if arg_strategy.has_implementation?
          arg_strategy.write_implementation(io)
        elsif !arg_strategy.remove_from_declaration?
          arg_name = arg_strategy.arg.name
          io << to_identifier(arg_name) << '=' << "lib_" << arg_name << LF
        end
      end
    end

    def callable : CallableInfo
      @vfunc
    end

    private def call_user_method(io)
      vfunc.args.join(io, ", ") { |param| io << to_identifier(param.name) }
    end

    private def return_type
      to_lib_type(vfunc.return_type, structs_as_void: true)
    end

    private def byte_offset
      struct_info = case object
                    when InterfaceInfo then object.as(InterfaceInfo).iface_struct
                    when ObjectInfo    then object.as(ObjectInfo).class_struct
                    end
      return nil unless struct_info
      struct_info.fields.find { |field| field.name == vfunc.name }.try &.byteoffset
    end

    private def proc_args(io)
      vfunc.args.each { |arg| io << ", " << to_lib_type(arg.type_info, structs_as_void: true) }
    end

    private def type_name
      to_crystal_type(@object, false)
    end

    private def vfunc_gi_annotations : String
      args = @vfunc.args
      String.build do |io|
        args_gi_annotations(io, args)
      end
    end

    private def call_user_method_with_lib_args(io)
      vfunc.args.join(io, ", ") do |arg|
        io << "lib_"
        io << to_identifier(arg.name)
      end
    end
  end
end
