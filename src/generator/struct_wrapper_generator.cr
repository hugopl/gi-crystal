module Generator
  class StructWrapperGenerator < Base
    include WrapperUtil

    @struct_info : StructInfo
    @namespace : Namespace

    def initialize(@namespace : Namespace, @struct_info : StructInfo)
    end

    def filename : String?
      "#{@struct_info.name.underscore}.cr"
    end

    def subject : String
      @struct_info.name
    end

    def skip?
      super || @struct_info.g_type_struct?
    end

    def do_generate(io : IO)
      io << "module " << to_type_name(@namespace.name) << LF
      doc_repo.doc(io, @struct_info)
      io << "class " << to_crystal_type(@struct_info, include_namespace: false) << LF
      io << "@pointer : Pointer(Void)\n"
      generate_struct_initialize(io)
      generate_g_type_method(io, @struct_info)
      generate_to_unsafe(io)
      generate_finalizer(io)

      generate_struct_accessors(io)
      MethodWrapperGenerator.generate(io, @struct_info.methods)
      io << "end\nend\n" # end-class, end-module
    end

    private def generate_struct_initialize(io : IO)
      if @struct_info.boxed?
        generate_boxed_initializer(io)
      elsif @struct_info.copyable?
        generate_struct_initializer(io)
      else
        Log.warn { "#{subject} struct has zero bytes and isn't a Boxed struct. Wrapper wont be safe!" }
        io << "def initialize(@pointer : Pointer(Void), _transfer : GICrystal::Transfer)\nend\n\n"
      end
    end

    def generate_boxed_initializer(io : IO)
      io << "def initialize(pointer : Pointer(Void), transfer : GICrystal::Transfer)\n"
      io << "raise ArgumentError.new if pointer.null?\n"
      io << "@pointer = if transfer.full?\n"
      io << "pointer\n"
      io << "else\n"
      io << "LibGObject.g_boxed_copy(" << to_crystal_type(@struct_info, include_namespace: false) << ".g_type, pointer)\n"
      io << "end\n"
      io << "end\n"
    end

    def generate_struct_initializer(io : IO)
      io << "def initialize(@pointer : Pointer(Void), _transfer)\n"
      io << "raise ArgumentError.new if @pointer.null?\n"
      io << "end\n"

      # Initialize by parameters
      io << "def self.new("
      ctor_args = [] of String
      io << @struct_info.fields.map do |field|
        "#{to_crystal_arg_decl(field.name)} : #{to_crystal_type(field.type_info)}? = nil"
      end.join(", ")
      io << ")\n"

      io << "_ptr = Pointer(Void).malloc(" << @struct_info.bytesize << ")\n"
      io << "_instance = new(_ptr, GICrystal::Transfer::Full)\n"
      generate_ctor_fields_assignment(io)
      io << "_instance\n"
      io << "end\n"
    end

    private def generate_ctor_fields_assignment(io)
      @struct_info.fields.each do |field|
        field_name = to_identifier(field.name)
        io << "_instance." << field.name << " = " << field_name << " unless " << field_name << ".nil?\n"
      end
    end

    private def generate_struct_accessors(io : IO)
      @struct_info.fields.each do |field|
        generate_getter(io, field)
        generate_setter(io, field)
      end
    end

    private def generate_getter(io : IO, field : FieldInfo)
      field_name = field.name
      Log.context.set(scope: "#{subject}.#{field_name}")
      io << "# Property getter\n"
      io << "def " << field_name << " : " << to_crystal_type(field.type_info) << LF
      io << "_var = (@pointer + " << field.byteoffset << ").as(Pointer(" << to_lib_type(field.type_info) << "))\n"
      io << convert_to_crystal("_var.value", field.type_info, :full) << LF
      io << "\nend\n"
    end

    private def generate_setter(io : IO, field : FieldInfo)
      field_name = field.name
      Log.context.set(scope: "#{subject}.#{field_name}=")
      io << "# Property setter\n"
      io << "def " << field_name << "=(value : " << to_crystal_type(field.type_info) << ")\n"
      io << "_var = (@pointer + " << field.byteoffset << ").as(Pointer(" << to_lib_type(field.type_info) << ")).value = "
      io << convert_to_lib("value", field.type_info, :full) << LF
      io << "value\n"
      io << "end\n"
    end

    private def generate_to_unsafe(io : IO)
      io << "def to_unsafe\n" \
            "@pointer\n" \
            "end\n"
    end

    private def generate_finalizer(io : IO)
      # Non-boxed structs are never owner by wrappers
      return unless @struct_info.boxed?

      io << "def finalize\n"
      io << "LibGObject.g_boxed_free(self.class.g_type, self)\n"
      io << "end\n"
    end
  end
end
