require "./wrapper_util"
require "./property_holder"
require "./method_holder"
require "./signal_holder"

module Generator
  class ObjectGen < FileGen
    include WrapperUtil
    include PropertyHolder
    include MethodHolder
    include SignalHolder

    private getter object : ObjectInfo
    @all_properties : Array(PropertyInfo)?

    def initialize(@object : ObjectInfo)
      super(@object.namespace)
    end

    def filename : String
      "#{@object.name.underscore}.cr"
    end

    def generate
      generate(filename)
    end

    private def parent_class
      parent = @object.parent
      return if parent.nil?

      "< #{to_crystal_type(parent, parent.namespace != namespace)}"
    end

    def type_name
      to_crystal_type(@object, false)
    end

    private def all_properties : Array(PropertyInfo)
      @all_properties = begin
        obj = @object
        props = [] of PropertyInfo
        while obj
          props.concat(obj.properties)
          obj = obj.parent
        end
        @object.interfaces.each do |iface|
          props.concat(iface.properties)
        end

        props.sort_by(&.name).uniq!(&.name)
      end
    end

    private def gobject_constructor_parameter_declaration : String
      String.build do |s|
        s << '*'
        all_properties.each do |prop|
          s << "," << to_crystal_arg_decl(prop.name) << " : " << to_crystal_type(prop.type_info) << "? = nil"
        end
      end
    end

    private def require_file(info : BaseInfo?) : String?
      return if info.nil?

      String.build do |s|
        s << "require \"."
        s << "./" << module_dir(info.namespace) if info.namespace != @object.namespace
        s << '/' << info.name.underscore << "\"\n"
      end
    end
  end
end
