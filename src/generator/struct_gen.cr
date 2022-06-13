module Generator
  class StructGen < FileGen
    include WrapperUtil
    include MethodHolder

    @struct : StructInfo

    def initialize(@struct : StructInfo)
      super(@struct.namespace)
    end

    def filename : String
      "#{@struct.name.underscore}.cr"
    end

    def scope : String
      "#{namespace.name}::#{@struct.name}"
    end

    def subject
      @struct.name
    end

    def skip?(key : String = subject) : Bool
      super || @struct.g_type_struct?
    end

    def type_name
      to_crystal_type(@struct, false)
    end

    def object
      @struct
    end

    def g_error?
      namespace.name == "GLib" && @struct.name == "Error"
    end

    def struct_new_method : String
      String.build do |s|
        s << "def self.new("
        s << @struct.fields.map do |field|
          "#{to_crystal_arg_decl(field.name)} : #{to_crystal_type(field.type_info)}? = nil"
        end.join(", ")
        s << ")\n"

        s << "_instance = allocate\n"
        generate_ctor_fields_assignment(s)
        s << "_instance\n"
        s << "end\n"
      end
    end

    private def generate_ctor_fields_assignment(io)
      @struct.fields.each do |field|
        field_name = to_identifier(field.name)
        io << "_instance." << field.name << " = " << field_name << " unless " << field_name << ".nil?\n"
      end
    end

    private def foreach_field
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

    private def generate_getter(io : IO, field : FieldInfo)
      field_name = field.name
      field_type = field.type_info
      is_pointer = field_type.pointer?

      if is_pointer
        io << "def " << field_name << "!\n"
        io << "self." << field_name << ".not_nil!"
        io << "\nend\n"
      end

      io << "def " << field_name << " : "
      field_type_name(io, field)
      io << LF

      io << "_var = (to_unsafe + " << field.byteoffset << ").as(Pointer(" << to_lib_type(field_type, structs_as_void: true) << "))\n"
      if is_pointer
        io << "return if _var.value.null?\n"
      end

      # Bindinged objects ctors expect a pointer to the object, if the same behavior would be used for
      # stdlib String class a constructor like `String.new(ptr : Pointer(Pointer(Void))` would need to exists,
      # but it doesn't (of course).
      obj_ptr_expr = !is_pointer && field_type.tag.interface? ? "_var" : "_var.value"
      io << convert_to_crystal(obj_ptr_expr, field.type_info, @struct.fields, :none) << LF
      io << "\nend\n"
    end

    private def generate_setter(io : IO, field : FieldInfo)
      field_name = field.name
      field_type = field.type_info
      is_pointer = field_type.pointer?
      field_lib_type = to_lib_type(field_type, structs_as_void: true)

      io << "def " << field_name << "=(value : "
      field_type_name(io, field)
      io << ")\n"

      io << "_var = (to_unsafe + " << field.byteoffset << ").as(Pointer(" << field_lib_type << "))"
      if !is_pointer && field_type.tag.interface?
        iface = field_type.interface
        if iface.is_a?(StructInfo) && iface.boxed?
          Log.warn { "Struct with non pointer boxed struct as parameter" }
        else
          io << "\n_var.copy_from(value.to_unsafe, sizeof(" << to_lib_type(object) << "))"
        end
      else
        io << ".value = "
        io << "value.nil? ? " << field_lib_type << ".null : " if is_pointer
        io << convert_to_lib("value", field_type, :none)
      end
      io << "\nvalue\n"
      io << "end\n"
    end
  end
end
