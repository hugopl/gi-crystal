require "./box_helper"

module Generator
  class SignalGen < Generator
    include WrapperUtil
    include BoxHelper

    getter obj : RegisteredTypeInfo
    getter signal : SignalInfo
    @signal_args : Array(ArgInfo)?
    @args_strategies : Array(ArgStrategy)

    def initialize(@obj : ObjectInfo | InterfaceInfo, @signal : SignalInfo)
      super(@obj.namespace)

      @args_strategies = ArgStrategy.find_strategies(@signal, :crystal_to_c)
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

    private def validation_args : String
      String.build do |s|
        @args_strategies.each do |arg_strategy|
          next if arg_strategy.remove_from_declaration?

          arg = arg_strategy.arg
          arg_type_info = arg.type_info

          s << to_identifier(arg.name) << " : ("
          s << to_crystal_type(arg_type_info, include_namespace: true)
          s << " | Nil" if arg.nullable?
          s << ").class,"
        end
      end
    end

    private def lean_proc_params : String
      String.build do |s|
        arg_strategies_to_proc_param_string(s, @signal, @args_strategies)
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

    macro render_emit_method
      render_emit_method(io)
    end

    private def render_emit_method(io : IO)
      io << "def emit("
      @args_strategies.each(&.render_declaration(io))
      io << ") : Nil\n"

      @args_strategies.each(&.write_implementation(io))

      # Signal emission
      io << "\nLibGObject.g_signal_emit_by_name(@source, \"" << @signal.name << "\""
      @args_strategies.each do |strategy|
        io << ", " << to_identifier(strategy.arg.name)
      end
      io << ")\n"
      io << "end\n"
    end
  end
end
