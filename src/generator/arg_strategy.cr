require "./box_helper"

module Generator
  abstract struct ArgPlan
    include Helpers
    include BoxHelper

    getter strategies : Array(ArgStrategy)

    def initialize(@strategies : Array(ArgStrategy))
    end

    abstract def match?(strategy : ArgStrategy, direction : ArgStrategy::Direction) : Bool
    abstract def generate_crystal_to_c_implementation(io : IO, strategy : ArgStrategy) : Nil
    abstract def generate_c_to_crystal_implementation(io : IO, strategy : ArgStrategy) : Nil
  end

  class ArgStrategy
    include Helpers

    enum Direction
      CToCrystal
      CrystalToC
    end

    property? remove_from_declaration : Bool = false
    property? capture_block : Bool = false
    getter method : CallableInfo
    getter arg : ArgInfo

    @implementation : IO::Memory?

    def self.find_strategies(method : CallableInfo, direction : Direction) : Array(ArgStrategy)
      strategies = method.args.map { |arg| ArgStrategy.new(method, arg) }
      {% for plan_class in %w(CallbackArgPlan
                             AsyncPatternArgPlan
                             TransferFullArgPlan
                             ArrayLengthArgPlan
                             OutArgUsedInReturnPlan
                             NullableArrayPlan
                             ArrayArgPlan
                             CallerAllocatesPlan
                             HandmadeArgPlan
                             GErrorArgPlan
                             BuiltInTypeArgPlan) %}
      plan = {{ plan_class.id }}.new(strategies)
      strategies.each do |strategy|
        if plan.match?(strategy, direction)
          strategy.add_implementation(plan, direction)
        end
      end
      {% end %}

      # Last argument of callbacks is user_data, i.e. must always be removed.
      if method.is_a?(CallbackInfo) && !strategies.empty?
        last_strategy = strategies.last
        last_strategy.remove_from_declaration = true
        last_strategy.clear_implementation
      end

      strategies
    end

    def initialize(@method : CallableInfo, @arg : ArgInfo)
    end

    def has_implementation? : Bool
      !@implementation.nil?
    end

    def clear_implementation
      @implementation = nil
    end

    def arg_type : TypeInfo
      @arg.type_info
    end

    def render_declaration(io : IO)
      return if remove_from_declaration?

      # ⚠️`capture_block` flag is used for GIO async methods, the generator must
      # create another version of the method with the block capture since `&callback : Proc(Nil)?
      # trigger a compiler error.
      #
      # As the generator needs a refactor to make it easier to add method overloads based on argument
      # strategies, for now I just set the captured block as non-nilable.
      null_mark = '?' if arg.nullable? && !capture_block?
      type = to_crystal_type(arg_type, is_arg: true)
      name = to_crystal_arg_decl(arg.name)
      io << '&' if capture_block?
      io << name << " : " << type << null_mark
      io << ',' if !capture_block? # Crystal bug(?) parsing foo(&capture : Proc(Nil),).
    end

    def add_implementation(arg_plan : ArgPlan, direction : Direction) : Nil
      io = @implementation ||= IO::Memory.new
      io << "# " << arg_plan.class.name << LF
      case direction
      in .c_to_crystal? then arg_plan.generate_c_to_crystal_implementation(io, self)
      in .crystal_to_c? then arg_plan.generate_crystal_to_c_implementation(io, self)
      end
    end

    def write_implementation(dest : IO) : Nil
      implementation = @implementation
      return if implementation.nil?

      implementation.rewind
      IO.copy(implementation, dest)
    end
  end

  struct ArrayLengthArgPlan < ArgPlan
    def match?(strategy : ArgStrategy, direction : ArgStrategy::Direction) : Bool
      arg_type = strategy.arg_type
      return false if arg_type.array_length < 0

      strategies[arg_type.array_length].remove_from_declaration = true
      true
    end

    def generate_crystal_to_c_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      arg_type = strategy.arg_type
      io << to_identifier(strategies[arg_type.array_length].arg.name) << " = " << to_identifier(arg.name)
      io << (arg.nullable? ? ".try(&.size) || 0" : ".size") << LF
    end

    def generate_c_to_crystal_implementation(io : IO, strategy : ArgStrategy) : Nil
    end
  end

  struct ArrayArgPlan < ArgPlan
    # FIXME: Remove/refactor the mess in this wrapper util
    include WrapperUtil

    def match?(strategy : ArgStrategy, direction : ArgStrategy::Direction) : Bool
      arg = strategy.arg
      return false if arg.nullable?
      return false unless arg.type_info.array?

      true
    end

    def generate_crystal_to_c_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      arg_name = to_identifier(arg.name)
      arg_type = arg.type_info

      array_fixed_len = arg_type.array_fixed_size
      if array_fixed_len > 0
        io << "raise ArgumentError.new(\"Enumerable of size < " << array_fixed_len << "\") "
        io << "if " << arg_name << ".size < " << array_fixed_len << "\n\n"
      end

      io << arg_name << " = "
      generate_array_to_unsafe(io, arg_name, arg.type_info)
    end

    def generate_c_to_crystal_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      arg_name = to_identifier(arg.name)
      arg_type = arg.type_info

      array_len = arg_type.array_length
      if array_len > 0
        len_arg = strategies[arg_type.array_length].arg
        len_arg_name = to_identifier(len_arg.name)
        param_type = to_crystal_type(arg_type.param_type)

        io << "lib_" << arg_name << " = lib_" << arg_name << ".as(Pointer(Pointer(Void)))\n"

        io << arg_name << "= Array(" << param_type << ").new(lib_" << len_arg_name << ") do |_i|\n"

        ptr_expr = "(lib_#{arg_name} + _i).value"
        # FIXME: Maybe convert_crystal should return a macro code that does that, instead of generate this,
        #        something like we do with transferArray, but need to be a macro since we need more type
        #        information.
        io << convert_to_crystal(ptr_expr, arg_type.param_type, nil, arg.ownership_transfer)
        io << "\nend\n"
      else
        io << "raise NotImplementedError.new\n"
      end
    end
  end

  struct NullableArrayPlan < ArgPlan
    # FIXME: Remove/refactor the mess in this wrapper util
    include WrapperUtil

    def match?(strategy : ArgStrategy, direction : ArgStrategy::Direction) : Bool
      return false if strategy.remove_from_declaration?

      arg = strategy.arg
      return false if arg.optional?
      return false if arg.type_info.interface.is_a?(CallbackInfo)
      return false unless arg.nullable?

      arg_type = arg.type_info
      return false if handmade_type?(arg_type)

      true
    end

    def generate_crystal_to_c_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      arg_type = arg.type_info
      arg_name = to_identifier(arg.name)

      generate_null_guard(io, arg_name, arg_type, nullable: arg.nullable?) do
        if arg_type.array? && !arg_type.param_type.tag.u_int8?
          generate_array_to_unsafe(io, arg_name, arg_type)
        else
          io << arg_name << ".to_unsafe"
        end
      end
    end

    def generate_c_to_crystal_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      arg_name = arg.name
      var = "lib_#{to_identifier(arg_name)}"
      io << to_identifier(arg_name) << '=' << convert_to_crystal(var, arg, strategies.map(&.arg), :none) << LF
    end
  end

  struct OutArgUsedInReturnPlan < ArgPlan
    @used_in_return = false

    def match?(strategy : ArgStrategy, direction : ArgStrategy::Direction) : Bool
      arg = strategy.arg
      @used_in_return = arg_used_in_return_type?(strategy.method, arg)
      return false if !(arg.optional? || @used_in_return)

      strategy.remove_from_declaration = true
      true
    end

    def generate_crystal_to_c_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg

      io << to_identifier(arg.name) << " = "
      if @used_in_return
        io << type_info_default_value(arg.type_info)
      else
        # FIXME: Move this use case into `type_info_default_value`
        type_name = to_lib_type(arg.type_info, structs_as_void: true)
        io << "Pointer(" << type_name << ").null"
      end
    end

    def generate_c_to_crystal_implementation(io : IO, strategy : ArgStrategy) : Nil
    end

    private def arg_used_in_return_type?(method, arg) : Bool
      arg_index = method.args.index(arg)
      type_info = method.return_type
      type_info.tag.array? && type_info.array_length == arg_index
    end
  end

  struct CallerAllocatesPlan < ArgPlan
    def match?(strategy : ArgStrategy, direction : ArgStrategy::Direction) : Bool
      arg = strategy.arg
      return false if !(arg.direction.out? && arg.caller_allocates? && !arg.type_info.array?)

      strategy.remove_from_declaration = true
      true
    end

    def generate_crystal_to_c_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      io << to_identifier(arg.name) << "=" << to_crystal_type(arg.type_info) << ".new"
    end

    def generate_c_to_crystal_implementation(io : IO, strategy : ArgStrategy) : Nil
    end
  end

  struct HandmadeArgPlan < ArgPlan
    def match?(strategy : ArgStrategy, direction : ArgStrategy::Direction) : Bool
      return false if strategy.remove_from_declaration?

      arg_type = strategy.arg_type
      return false unless handmade_type?(arg_type)

      true
    end

    def generate_crystal_to_c_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      arg_type = strategy.arg_type
      type = to_crystal_type(arg_type)
      var = to_identifier(arg.name)

      io << var << '='
      if arg.nullable?
        io << "if " << var << ".nil?\n"
        io << "Pointer(Void).null\n" \
              "els" # If arg can be null the next if will turn into a elsif, ugly but works.
      end
      io << "if !" << var << ".is_a?(" << type << ")\n"
      io << type << ".new(" << var << ").to_unsafe\n"
      io << "else\n"
      io << var << ".to_unsafe\n"
      io << "end\n"
    end

    def generate_c_to_crystal_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      arg_type = strategy.arg_type
      type = to_crystal_type(arg_type)
      var = to_identifier(arg.name)

      io << var << '=' << type << ".new(lib_" << var << ", :none)"
      io << " unless lib_" << var << ".null?" if arg.nullable?
      io << LF
    end
  end

  struct TransferFullArgPlan < ArgPlan
    def match?(strategy : ArgStrategy, direction : ArgStrategy::Direction) : Bool
      return false if strategy.remove_from_declaration?

      arg = strategy.arg
      return false if !arg.ownership_transfer.full?

      case arg.type_info.interface
      when ObjectInfo, InterfaceInfo then true
      else
        false
      end
    end

    def generate_crystal_to_c_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      obj = arg.type_info.interface.as(RegisteredTypeInfo)

      var = to_identifier(arg.name)
      io << "GICrystal.ref(" << var << ")\n"
    end

    def generate_c_to_crystal_implementation(io : IO, strategy : ArgStrategy) : Nil
    end
  end

  struct GErrorArgPlan < ArgPlan
    def match?(strategy : ArgStrategy, direction : ArgStrategy::Direction) : Bool
      return false if direction.crystal_to_c?
      return false if strategy.remove_from_declaration?

      arg_type = strategy.arg.type_info
      return false unless arg_type.tag.error?

      true
    end

    def generate_crystal_to_c_implementation(io : IO, strategy : ArgStrategy) : Nil
    end

    def generate_c_to_crystal_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      arg_name = to_identifier(arg.name)
      namespace = to_type_name(strategy.method.namespace.name)
      transfer = arg.ownership_transfer
      io << arg_name << '=' << namespace
      io << ".gerror_to_crystal(lib_" << arg_name << ".as(Pointer(LibGLib::Error)), GICrystal::Transfer::" << transfer << ")\n"
    end
  end

  struct BuiltInTypeArgPlan < ArgPlan
    def match?(strategy : ArgStrategy, direction : ArgStrategy::Direction) : Bool
      return false if strategy.remove_from_declaration?

      type_info = strategy.arg.type_info
      return false if handmade_type?(type_info)

      tag = type_info.tag
      return tag.unichar? if direction.crystal_to_c?

      case tag
      when .interface?, .utf8?, .filename?, .boolean?
        true
      else
        false
      end
    end

    def generate_crystal_to_c_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      arg_name = to_identifier(arg.name)
      type_info = arg.type_info
      return unless type_info.tag.unichar?
      io << arg_name << '=' << convert_to_lib(arg_name, type_info, :none, arg.nullable?) << LF
    end

    def generate_c_to_crystal_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      type_info = arg.type_info

      arg_name = to_identifier(arg.name)
      io << arg_name << '=' << convert_to_crystal("lib_#{arg_name}", type_info, nil, arg.ownership_transfer)
      io << " unless lib_" << arg_name << ".null?" if arg.nullable?
      io << LF
    end
  end

  struct CallbackArgPlan < ArgPlan
    def match?(strategy : ArgStrategy, direction : ArgStrategy::Direction) : Bool
      arg = strategy.arg
      type_info = arg.type_info
      callback = type_info.interface
      return false unless callback.is_a?(CallbackInfo)

      idx = strategies.index(strategy)
      return false if idx.nil? || idx != strategies.size - 3

      user_data_arg = strategies[idx + 1].arg
      return false unless user_data_arg.type_info.tag.void?

      destroy_notify_arg = strategies[idx + 2].arg
      destroy_notify_arg_cb = destroy_notify_arg.type_info.interface
      return false if !destroy_notify_arg_cb.is_a?(CallbackInfo) || destroy_notify_arg_cb.name != "DestroyNotify"

      strategies[idx + 1].remove_from_declaration = true
      strategies[idx + 2].remove_from_declaration = true
      true
    end

    def generate_crystal_to_c_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      type_info = arg.type_info
      callback = type_info.interface.as(CallbackInfo)
      idx = strategies.index!(strategy)
      user_data_arg = strategies[idx + 1].arg
      destroy_notify_arg = strategies[idx + 2].arg

      callback_var = to_identifier(arg.name)
      userdata_var = to_identifier(user_data_arg.name)
      destroy_notify_var = to_identifier(destroy_notify_arg.name)
      io << "if " << callback_var << LF

      generate_box(io, callback_var, callback, :callback)

      io << userdata_var << " = GICrystal::ClosureDataManager.register(_box)\n"
      io << destroy_notify_var << " = ->GICrystal::ClosureDataManager.deregister(Pointer(Void)).pointer\n"
      io << "else\n"
      io << callback_var << '=' << userdata_var << '=' << destroy_notify_var << "= Pointer(Void).null\n"
      io << "end\n"
    end

    def generate_c_to_crystal_implementation(io : IO, strategy : ArgStrategy) : Nil
    end
  end

  struct AsyncPatternArgPlan < ArgPlan
    def match?(strategy : ArgStrategy, direction : ArgStrategy::Direction) : Bool
      arg = strategy.arg
      type_info = arg.type_info
      callback = type_info.interface
      return false unless callback.is_a?(CallbackInfo)
      return false if callback.name != "AsyncReadyCallback" || callback.namespace.name != "Gio"

      idx = strategies.index(strategy)
      return false if idx.nil? || idx != strategies.size - 2

      user_data_arg = strategies[idx + 1].arg
      return false unless user_data_arg.type_info.tag.void?

      strategy.capture_block = true
      strategies[idx + 1].remove_from_declaration = true
    end

    def generate_crystal_to_c_implementation(io : IO, strategy : ArgStrategy) : Nil
      arg = strategy.arg
      type_info = arg.type_info
      idx = strategies.index(strategy).not_nil!

      callback_var = to_identifier(arg.name)
      user_data_var = to_identifier(strategies[idx + 1].arg.name)
      io << user_data_var << " = ::Box.box(" << callback_var << ")\n"
      io << callback_var << " = if " << callback_var << ".nil?\n"
      io << "  Pointer(Void).null\n"
      io << "else\n"
      io << "  ->(gobject : Void*, result : Void*, box : Void*) {\n"
      io << "    unboxed_callback = ::Box(Gio::AsyncReadyCallback).unbox(box)\n"
      io << "    GICrystal::ClosureDataManager.deregister(box)\n"
      io << "    unboxed_callback.call(typeof(self).new(gobject, :none), Gio::AbstractAsyncResult.new(result, :none))\n"
      io << "  }.pointer\n"
      io << "end\n"
    end

    def generate_c_to_crystal_implementation(io : IO, strategy : ArgStrategy) : Nil
    end
  end
end
