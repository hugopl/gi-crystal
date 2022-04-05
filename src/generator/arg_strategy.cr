module Generator
  abstract struct ArgPlan
    include Helpers

    getter strategies : Array(ArgStrategy)

    def initialize(@strategies : Array(ArgStrategy))
    end

    abstract def plan_for(strategy : ArgStrategy) : Nil

    macro add_implementation(&block)
      strategy.add_implementation({{ @type.name.stringify }}) {{ block }}
    end
  end

  class ArgStrategy
    include Helpers

    property? remove_from_declaration : Bool
    getter method : FunctionInfo
    getter arg : ArgInfo

    @implementation : IO::Memory?

    def self.find_strategies(method : FunctionInfo)
      strategies = method.args.map { |arg| ArgStrategy.new(method, arg) }
      {% for plan_class in %w(ArrayLengthArgPlan
                             OutArgUsedInReturnPlan
                             NullableArrayPlan
                             ArrayArgPlan
                             CallerAllocatesPlan
                             HandmadeArgPlan
                             TransferFullArgPlan
                             CallbackArgPlan) %}
      plan = {{ plan_class.id }}.new(strategies)
      strategies.each do |strategy|
        plan.plan_for(strategy)
      end
      {% end %}

      strategies
    end

    def initialize(@method : FunctionInfo, @arg : ArgInfo)
      @remove_from_declaration = false
    end

    def arg_type : TypeInfo
      @arg.type_info
    end

    def render_declaration(io : IO)
      return if remove_from_declaration?

      # Default arg declaration
      null_mark = '?' if arg.nullable?
      type = to_crystal_type(arg_type, is_arg: true)
      name = to_crystal_arg_decl(arg.name)
      io << name << " : " << type << null_mark
    end

    def render_implementation(io : IO)
    end

    # Use ArgPlan macro `add_implementation` instead, to auto-fill the arg_plan parameter
    def add_implementation(arg_plan : String)
      io = @implementation ||= IO::Memory.new
      io << "# " << arg_plan << LF
      yield(io)
      io << LF
    end

    def write_implementation(dest : IO) : Nil
      implementation = @implementation
      return if implementation.nil?

      implementation.rewind
      IO.copy(implementation, dest)
    end
  end

  struct ArrayLengthArgPlan < ArgPlan
    def plan_for(strategy : ArgStrategy) : Nil
      arg_type = strategy.arg_type
      return if arg_type.array_length < 0

      strategies[arg_type.array_length].remove_from_declaration = true

      arg = strategy.arg
      add_implementation do |io|
        io << to_identifier(strategies[arg_type.array_length].arg.name) << " = " << to_identifier(arg.name)
        io << (arg.nullable? ? ".try(&.size) || 0" : ".size")
      end
    end
  end

  struct ArrayArgPlan < ArgPlan
    # FIXME: Remove/refactor the mess in this wrapper util
    include WrapperUtil

    def plan_for(strategy : ArgStrategy) : Nil
      arg = strategy.arg
      return if arg.nullable?
      return unless arg.type_info.array?

      arg_name = to_identifier(arg.name)
      add_implementation do |io|
        io << arg_name << " = "
        generate_array_to_unsafe(io, arg_name, arg.type_info)
      end
    end
  end

  struct NullableArrayPlan < ArgPlan
    # FIXME: Remove/refactor the mess in this wrapper util
    include WrapperUtil

    def plan_for(strategy : ArgStrategy) : Nil
      arg = strategy.arg
      return if arg.optional?
      return unless arg.nullable?

      arg_name = to_identifier(arg.name)
      arg_type = arg.type_info
      add_implementation do |io|
        generate_null_guard(io, arg_name, arg_type, nullable: arg.nullable?) do
          if arg_type.array?
            generate_array_to_unsafe(io, arg_name, arg_type)
          else
            io << arg_name << ".to_unsafe"
          end
        end
      end
    end
  end

  struct OutArgUsedInReturnPlan < ArgPlan
    def plan_for(strategy : ArgStrategy) : Nil
      arg = strategy.arg
      used_in_return = arg_used_in_return_type?(strategy.method, arg)
      return if !(arg.optional? || used_in_return)

      strategy.remove_from_declaration = true
      add_implementation do |io|
        io << to_identifier(arg.name) << " = "
        if used_in_return
          io << type_info_default_value(arg.type_info)
        else
          # FIXME: Move this use case into `type_info_default_value`
          type_name = to_lib_type(arg.type_info, structs_as_void: true)
          io << "Pointer(" << type_name << ").null"
        end
      end
    end

    private def arg_used_in_return_type?(method, arg) : Bool
      arg_index = method.args.index(arg)
      type_info = method.return_type
      type_info.tag.array? && type_info.array_length == arg_index
    end
  end

  struct CallerAllocatesPlan < ArgPlan
    def plan_for(strategy : ArgStrategy) : Nil
      arg = strategy.arg
      return if !(arg.direction.out? && arg.caller_allocates? && !arg.type_info.array?)

      strategy.remove_from_declaration = true
      add_implementation do |io|
        io << to_identifier(arg.name) << "=" << to_crystal_type(arg.type_info) << ".new"
      end
    end
  end

  struct HandmadeArgPlan < ArgPlan
    def plan_for(strategy : ArgStrategy) : Nil
      return if strategy.remove_from_declaration?

      arg_type = strategy.arg_type
      return unless BindingConfig.handmade?(arg_type)

      add_implementation do |io|
        type = to_crystal_type(arg_type)
        var = to_identifier(strategy.arg.name)
        io << var << "=" << type << ".new(" << var << ") unless " << var << ".is_a?(" << type << ")\n"
      end
    end
  end

  struct TransferFullArgPlan < ArgPlan
    def plan_for(strategy : ArgStrategy) : Nil
      return if strategy.remove_from_declaration?

      arg = strategy.arg
      return if !arg.ownership_transfer.full?

      obj = arg.type_info.interface.as?(ObjectInfo)
      return if obj.nil?

      add_implementation do |io|
        io << "LibGObject." << obj.ref_function << '(' << to_identifier(arg.name) << ")"
      end
    end
  end

  struct CallbackArgPlan < ArgPlan
    def plan_for(strategy : ArgStrategy) : Nil
      # TODO: Remove user_data and destroy args
    end
  end
end
