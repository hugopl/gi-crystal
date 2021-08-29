module Generator
  module WrapperUtil
    def generate_g_type_method(io : IO, info : RegisteredTypeInfo)
      type_init = info.type_init
      return if type_init.nil?

      io << "# Returns the type id (GType) registered in GLib type system.\n"
      io << "def self.g_type : UInt64\n"
      io << to_lib_namespace(info.namespace) << "." << type_init
      io << "\nend\n"
    end

    def generate_ref_count(io : IO)
      code = <<-EOS
      # Returns GObject reference counter.
      def ref_count
        to_unsafe.as(Pointer(LibGObject::Object)).value.ref_count
      end

      EOS
      io << code
    end

    def generate_null_guard(io : IO, identifier : String, type : TypeInfo, nullable : Bool = true) : Nil
      if nullable
        io << identifier << " = if " << identifier << ".nil?\n"
        io << to_lib_type(type, structs_as_void: true) << ".null\n"
        io << "else\n"
        yield(io)
        io << "\nend\n"
      else
        yield(io)
      end
    end

    def generate_array_to_unsafe(io : IO, identifier : String, type : TypeInfo)
      tag = type.param_type.tag

      io << identifier << ".to_a"
      if type.param_type.g_value?
        io << ".map(&.to_g_value.c_g_value)"
      elsif tag.interface? || tag.utf8? || tag.filename?
        io << ".map(&.to_unsafe)"
      end
      io << ".to_unsafe\n"
    end
  end
end
