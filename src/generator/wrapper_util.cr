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
  end
end
