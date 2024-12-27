module Generator
  module WrapperUtil
    def generate_null_guard(io : IO, identifier : String, type : TypeInfo, nullable : Bool = true, &) : Nil
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
      lib_ptype = to_lib_type(param_type)
      tag = param_type.tag

      io << identifier << ".to_a"
      if handmade_type?(param_type)
        ptype_name = to_crystal_type(param_type)
        if param_type.pointer?
          io << ".map { |_i| " << ptype_name << ".new(_i).to_unsafe }"
        else
          # FIXME: This is copying too much and can be optimized
          #        Main use case of this are methods receiving an array of GValues
          io << ".map { |_i| " << ptype_name << ".new(_i).to_unsafe.as(Pointer(" << lib_ptype << ")).value }"
        end
      elsif tag.interface? || tag.utf8? || tag.filename?
        io << ".map(&.to_unsafe)"
      end
      io << ".to_unsafe.as(Pointer(" << lib_ptype << "))\n"
    end
  end
end
