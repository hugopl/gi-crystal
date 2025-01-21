module Generator
  abstract class StructGen < FileGen
    include WrapperUtil
    include MethodHolder

    @struct : StructInfo

    def initialize(@struct : StructInfo)
      super(@struct.namespace)
    end

    def self.new(info : StructInfo)
      type_config = BindingConfig.for(info.namespace).type_config(info.name)
      case type_config.binding_strategy
      in .auto?
        if info.copyable?
          if info.pod_type?
            StackStructGen.new(info)
          else
            HeapStructGen.new(info)
          end
        else
          HeapWrapperStructGen.new(info)
        end
      in .stack_struct?
        StackStructGen.new(info)
      in .heap_struct?
        HeapStructGen.new(info)
      in .heap_wrapper_struct?
        HeapWrapperStructGen.new(info)
      end
    end

    def filename : String
      "#{@struct.name.underscore}.cr"
    end

    def scope : String
      "#{namespace.name}::#{@struct.name}"
    end

    def type_name
      to_crystal_type(@struct, false)
    end

    def object
      @struct
    end

    def struct_new_method : String
      String.build do |s|
        s << "def self.new("
        @struct.fields.each do |field|
          next if ignore_field?(field)
          next if field.type_info.pointer?

          s << "#{to_crystal_arg_decl(field.name)} : #{to_crystal_type(field.type_info)}? = nil, "
        end
        s << ")\n"

        s << "_instance = allocate\n"
        generate_ctor_fields_assignment(s)
        s << "_instance\n"
        s << "end\n"
      end
    end

    private def generate_ctor_fields_assignment(io : IO, var : String = "_instance")
      @struct.fields.each do |field|
        next if ignore_field?(field)
        next if field.type_info.pointer?

        field_name = to_identifier(field.name)
        io << var << '.' << field.name << " = " << field_name << " unless " << field_name << ".nil?\n"
      end
    end

    private def foreach_field(&)
      @struct.fields.each do |field|
        with_log_scope("#{scope} #{field.name} field") do
          yield(field)
        end
      end
    end

    private def field_type_name(io, field)
      field_type = field.type_info
      is_pointer = field_type.pointer?
      io << to_crystal_type(field_type)
      io << "?" if is_pointer
    end

    private def ignore_field?(field : FieldInfo) : Bool
      config.type_config(@struct.name).ignore_field?(field.name)
    end

    private def render_getters_and_setters(io : IO)
      foreach_field do |field|
        next if ignore_field?(field)

        generate_getter(io, field)
        generate_setter(io, field)
      end
    end

    private def generate_getter(io : IO, field : FieldInfo)
      field_name = field.name
      field_type = field.type_info
      is_pointer = field_type.pointer?

      if is_pointer
        io << "def " << to_call(field_name) << "!\n"
        io << "self." << field_name << ".not_nil!"
        io << "\nend\n"
      end

      io << "def " << to_call(field_name) << " : "
      field_type_name(io, field)
      io << LF

      io << "value = to_unsafe.as(Pointer(" << to_lib_type(@struct) << ")).value." << to_identifier(field_name) << LF
      if is_pointer
        io << "return if value.null?\n"
        type = case field_type.tag
               when .utf8?, .filename? then "UInt8"
               else
                 "Void"
               end
        io << "value = value.as(Pointer(" << type << "))\n"
      end

      io << convert_to_crystal("value", field.type_info, @struct.fields, :none) << LF
      io << "\nend\n"
    end

    private def generate_setter(io : IO, field : FieldInfo)
      field_type = field.type_info
      is_pointer = field_type.pointer?
      return if is_pointer

      field_name = field.name
      field_lib_type = to_lib_type(field_type, structs_as_void: true)

      io << "def " << to_call(field_name) << "=(value : "
      field_type_name(io, field)
      io << ")\n"

      io << "_var = (to_unsafe + " << field.byteoffset << ").as(Pointer(" << field_lib_type << "))"
      if field_type.tag.interface?
        iface = field_type.interface
        if iface.is_a?(StructInfo) && iface.boxed?
          Log.warn { "Struct with non pointer boxed struct as parameter" }
        else
          io << "\n_var.copy_from(value.to_unsafe, sizeof(" << to_lib_type(object) << "))"
        end
      else
        io << ".value = "
        io << convert_to_lib("value", field_type, :none, false)
      end
      io << "\nvalue\n"
      io << "end\n"
    end
  end
end
