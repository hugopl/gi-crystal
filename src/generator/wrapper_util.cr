require "./method_wrapper_generator"

module Generator
  module WrapperUtil
    def generate_method_wrappers(io : IO, methods : Array(FunctionInfo))
      methods.each do |func|
        next if func.deprecated?

        gen = MethodWrapperGenerator.new(func)
        gen.generate(io)
      end
    end

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
  end
end
