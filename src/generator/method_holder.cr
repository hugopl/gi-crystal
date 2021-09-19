require "./method_gen"

module Generator
  module MethodHolder
    macro render_methods
      object.methods.each do |method|
        gen = MethodGen.new(method)
        gen.generate(io) unless gen.ignore?
      end
    end
  end
end
