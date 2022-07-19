require "./struct_gen"

module Generator
  class StackStructGen < StructGen
    def initialize(info : StructInfo)
      super(info)
    end

    private def generate_getter(io : IO, field : FieldInfo)
      field_name = field.name
      io << "delegate :" << to_call(field_name) << ", to: @data\n"
    end

    private def generate_setter(io : IO, field : FieldInfo)
      return if field.type_info.pointer?

      field_name = field.name
      io << "delegate :" << to_call(field_name) << "=, to: @data\n"
    end

    macro render_initialize
      render_initialize(io)
    end

    def render_initialize(io : IO)
      io << "def initialize("
      io << @struct.fields.map do |field|
        "#{to_crystal_arg_decl(field.name)} : #{to_crystal_type(field.type_info)}? = nil"
      end.join(", ")
      io << ")\n"
      io << "@data = " << to_lib_type(@struct) << ".new\n"
      generate_ctor_fields_assignment(io, "@data")
      io << "end\n"
    end
  end
end
