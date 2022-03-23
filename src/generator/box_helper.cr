module Generator
  module BoxHelper
    enum BoxType
      FullSignal
      LeanSignal
      Callback

      def signal? : Bool
        full_signal? || lean_signal?
      end
    end

    def generate_box(io : IO, callable_var : String, callable : CallableInfo, box_type : BoxType) : Nil
      io << "_box = ::Box.box(" << callable_var << ")\n"
      io << callable_var << " = " << "->("
      io << "_lib_sender : Pointer(Void), " if box_type.signal?
      generate_lib_args(io, callable)
      io << "_lib_box : Pointer(Void), " if box_type.signal?
      io << ") {\n"

      if box_type.full_signal?
        io << "_sender = " << convert_to_crystal("_lib_sender", callable.container.not_nil!, nil, :none) << LF
      end

      args_strategies = ArgStrategy.find_strategies(callable, :c_to_crystal)
      args_strategies.each do |arg_strategy|
        if arg_strategy.has_implementation?
          arg_strategy.write_implementation(io)
        else
          arg_name = arg_strategy.arg.name
          io << to_identifier(arg_name) << '=' << "lib_" << arg_name << LF
        end
      end

      generate_unbox_call(io, callable, args_strategies, box_type)

      io << "}.pointer\n"
    end

    private def generate_lib_args(io : IO, callable : CallableInfo)
      is_signal = callable.is_a?(SignalInfo)

      callable.args.each do |arg|
        # If arg_type is Void, it's probably a struct, GObjIntrospection doesn't inform that signal args are pointer when
        # they are structs
        arg_type = to_lib_type(arg.type_info, structs_as_void: true)
        arg_type = "Pointer(#{arg_type})" if is_signal && arg_type == "Void"
        arg_name = to_identifier(arg.name)
        io << "lib_" << arg_name << " :  " << arg_type << ", "
      end
    end

    private def generate_unbox_call(io : IO, callable : CallableInfo, args_strategies : Array(ArgStrategy), box_type : BoxType)
      if box_type.signal?
        user_data_var = "_lib_box"
      else
        last_arg = args_strategies.last?
        user_data_var = if last_arg
                          to_identifier(args_strategies.last.arg.name)
                        else
                          Log.warn { "Callback without user_data!" }
                          "Pointer(Void).null"
                        end
      end
      io << "::Box(Proc("
      io << to_crystal_type(callable.container.not_nil!) << ',' if box_type.full_signal?
      callable_to_crystal_types(io, callable)
      io << ")).unbox(" << user_data_var << ").call("
      io << "_sender," if box_type.full_signal?
      args_strategies.each do |strategy|
        io << to_identifier(strategy.arg.name) << ", " unless strategy.remove_from_declaration?
      end

      io << ")\n"
    end
  end
end
