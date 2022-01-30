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

    def do_generate(io : IO)
      generate_struct_accessors(io)
      MethodWrapperGenerator.generate(io, @struct.methods)
      io << "end\nend\n" # end-class, end-module
    end

    def g_error?
      namespace.g_lib? && @struct.name == "Error"
    end

    def struct_new_method : String
      String.build do |s|
        s << "def self.new("
        s << @struct.fields.map do |field|
          "#{to_crystal_arg_decl(field.name)} : #{to_crystal_type(field.type_info)}? = nil"
        end.join(", ")
        s << ")\n"

        s << "_ptr = Pointer(Void).malloc(" << @struct.bytesize << ")\n"
        s << "_instance = new(_ptr, GICrystal::Transfer::None)\n"
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

    private def struct_accessors : String
      String.build do |s|
        @struct.fields.each do |field|
          with_log_scope("#{scope} #{field.name} field") do
            generate_getter(s, field)
            generate_setter(s, field)
          end
        end
      end
    end

    private def generate_getter(io : IO, field : FieldInfo)
      field_name = field.name
      io << "def " << field_name << " : " << to_crystal_type(field.type_info) << LF
      io << "# Property getter\n"
      io << "_var = (@pointer + " << field.byteoffset << ").as(Pointer(" << to_lib_type(field.type_info, structs_as_void: true) << "))\n"
      io << convert_to_crystal("_var.value", field.type_info, @struct.fields, :none) << LF
      io << "\nend\n"
    end

    private def generate_setter(io : IO, field : FieldInfo)
      field_name = field.name
      io << "def " << field_name << "=(value : " << to_crystal_type(field.type_info) << ")\n"
      io << "# Property setter\n"
      io << "_var = (@pointer + " << field.byteoffset << ").as(Pointer(" << to_lib_type(field.type_info, structs_as_void: true) << ")).value = "
      io << convert_to_lib("value", field.type_info, :none) << LF
      io << "value\n"
      io << "end\n"
    end
  end
end
