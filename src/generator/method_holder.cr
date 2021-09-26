require "./method_gen"

module Generator
  module MethodHolder
    macro render_methods
      each_object_method do |method|
        gen = MethodGen.new(method)
        gen.generate(io) unless gen.ignore?
      end
    end

    # This exists just to be overwritten by e.g. interface
    def each_object_method
      object.methods.each do |method|
        yield(method)
      end
    end
  end
end
