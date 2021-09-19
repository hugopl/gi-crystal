require "./property_gen"

module Generator
  module PropertyHolder
    macro render_properties
      object.properties.each do |prop|
        PropertyGen.new(prop).generate(io)
      end
    end
  end
end
