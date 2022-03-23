require "./box_helper"

module Generator
  class SignalGen < Generator
    include WrapperUtil
    include BoxHelper

    getter obj : RegisteredTypeInfo
    getter signal : SignalInfo
    @signal_args : Array(ArgInfo)?

    def initialize(@obj : ObjectInfo | InterfaceInfo, @signal : SignalInfo)
      super(@obj.namespace)
    end

    def filename : String?
    end

    def subject : String
      "#{@obj.name}::#{signal_type}"
    end

    def scope
      "#{@obj.namespace.name}::#{@obj.name} #{@signal.name} signal"
    end

    private def signal_type
      "#{@signal.name.tr("-", "_").camelcase}Signal"
    end

    private def has_return_value?
      !@signal.return_type.tag.void?
    end

    private def signal_args
      @signal_args ||= @signal.args.reject do |arg|
        BindingConfig.for(arg.namespace).ignore?(to_crystal_type(arg.type_info, false))
      end
    end

    private def lean_proc_params : String
      String.build do |s|
        callable_to_crystal_types(s, @signal)
      end
    end

    private def full_proc_params : String
      "#{to_crystal_type(@obj)},#{lean_proc_params}"
    end

    macro render_box(box_type)
      render_box(io, {{ box_type }})
    end

    def render_box(io : IO, box_type : BoxType)
      generate_box(io, "handler", @signal, box_type)
    end

    private def signal_emit_method : String
      # FIXME: Use ArgStrategy classe to handle arguments here.
      String.build do |s|
        arg_vars = signal_args.map { |arg| to_identifier(arg.name) }

        # Emit declaration
        s << "def emit("
        s << signal_args.map_with_index do |arg, i|
          null_mark = "?" if arg.nullable?
          "#{arg_vars[i]} : #{to_crystal_type(arg.type_info, is_arg: true)}#{null_mark}"
        end.join(",")
        s << ") : Nil\n"

        generate_handmade_types_param_conversion(s, signal_args)

        # Signal emission
        s << "LibGObject.g_signal_emit_by_name(@source, \"" << @signal.name << "\""
        arg_vars.each do |arg|
          s << ", " << arg
        end
        s << ")\n"
        s << "end\n"
      end
    end
  end
end
