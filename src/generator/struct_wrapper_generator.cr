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

    def boxed? : Bool
      @struct_info.bytesize.zero?
    end

    def do_generate(io : IO)
      io << "module " << to_type_name(@namespace.name) << LF
      io << "class " << to_crystal_type(@struct_info, include_namespace: false) << LF
      io << "@pointer : Pointer(Void)\n" \
            "@transfer : GICrystal::Transfer\n"
      generate_struct_initialize(io)
      # Ideally we shouldn't bind the structs that represent a GObject type, but some methods require these types, so
      # for now we only generate constructors for them.
      unless @struct_info.gtype_struct?
        generate_struct_accessors(io)
        generate_method_wrappers(io, @struct_info.methods)
      end
      generate_to_unsafe(io)
      generate_finalizer(io)

      io << "end\nend\n" # end-class, end-module
    end

    private def generate_struct_initialize(io : IO)
      io << "def initialize(@pointer, @transfer)\n"
      io << "raise ArgumentError.new if @pointer.null?\n"
      io << "end\n"

      # Boxed structs are opaque pointers, the user isn't allowed to construct them.
      return if boxed?

      # Initialize by parameters
      io << "def self.new("
      ctor_args = [] of String
      io << @struct_info.fields.map do |field|
        "#{to_crystal_arg_decl(field.name)} : #{to_crystal_type(field.type_info)}? = nil"
      end.join(", ")
      io << ")\n" \
            "_ptr = LibGLib.g_malloc0(" << @struct_info.bytesize << ")\n"
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
      return unless boxed?

      io << "def finalize\n" \
            "return unless @transfer.full?\n"
      io << "LibGLib.g_boxed_free(" << to_lib_namespace(@namespace) << '.' << to_get_type_function(@struct_info) << ", self)\n"
      io << "end\n"
    end
  end
end
