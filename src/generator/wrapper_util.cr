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
