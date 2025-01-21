require "./method_gen"

module Generator
  module MethodHolder
    macro render_methods
      each_object_method do |method|
        next if config.type_config(object.name).ignore_method?(method.name)
        next if method.flags.constructor? && method.args.empty? && object.is_a?(StructInfo)
        next if config.lib_ignore?(method.symbol)

        MethodGen.new(object, method).generate(io)
      end
    end

    # This exists just to be overwritten by e.g. interface
    def each_object_method(&)
      object.methods.each do |method|
        yield(method)
      end
    end
  end
end
