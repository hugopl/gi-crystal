module Generator
  module WrapperUtil
    def generate_null_guard(io : IO, identifier : String, type : TypeInfo, nullable : Bool = true) : Nil
      io << identifier << " = "
      if nullable
        io << "if " << identifier << ".nil?\n"
        io << to_lib_type(type, structs_as_void: true) << ".null\n"
        io << "else\n"
        yield(io)
        io << "\nend\n"
      else
        yield(io)
      end
    end

    # FIXME: Possible buffer overflow... need to be sure we send a null terminated array if needed
    def generate_array_to_unsafe(io : IO, identifier : String, type : TypeInfo)
      param_type = type.param_type
      tag = param_type.tag

      io << identifier << ".to_a"
      if BindingConfig.handmade?(param_type)
        ptype_name = to_crystal_type(param_type)
        if param_type.pointer?
          io << ".map { |_i| " << ptype_name << ".new(_i).to_unsafe }"
        else
          # FIXME: This is copying too much and can be optimized
          #        Main use case of this are methods receiving an array of GValues
          lib_ptype = to_lib_type(param_type)
          io << ".map { |_i| " << ptype_name << ".new(_i).to_unsafe.as(Pointer(" << lib_ptype << ")).value }"
        end
      elsif tag.interface? || tag.utf8? || tag.filename?
        io << ".map(&.to_unsafe)"
      end
      io << ".to_unsafe\n"
    end

    private def generate_method_wrapper_args(io : IO, args : Array(ArgInfo))
      io << "("
      io << args.map do |arg|
        null_mark = "?" if arg.nullable?
        type = to_crystal_type(arg.type_info, is_arg: true)
        "#{to_crystal_arg_decl(arg.name)} : #{type}#{null_mark}"
      end.join(", ")
      io << ")"
    end

    private def generate_handmade_types_param_conversion(io : IO, args : Array(ArgInfo))
      args.each do |arg|
        if BindingConfig.handmade?(arg.type_info)
          type = to_crystal_type(arg.type_info)
          var = to_identifier(arg.name)
          io << var << "=" << type << ".new(" << var << ") unless " << var << ".is_a?(" << type << ")\n"
        end
      end
    end
  end
end
