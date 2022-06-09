module GObject
  # :nodoc:
  # This annotation is used to identify user types that inherit from GObject from binding types that does the same.
  annotation GeneratedWrapper
  end

  class Object
    macro inherited
      {% unless @type.annotation(GObject::GeneratedWrapper) %}
        # GType for the new created type
        @@_g_type : UInt64 = 0

        def self.g_type : UInt64
          if LibGLib.g_once_init_enter(pointerof(@@_g_type)) != 0
            g_type = {{ @type.superclass.id }}._register_derived_type({{ @type.id }},
              ->_class_init(Pointer(LibGObject::TypeClass), Pointer(Void)),
              ->_instance_init(Pointer(LibGObject::TypeInstance), Pointer(LibGObject::TypeClass)))

            LibGLib.g_once_init_leave(pointerof(@@_g_type), g_type)
          end

          @@_g_type
        end

        # :nodoc:
        def self._class_init(klass : Pointer(LibGObject::TypeClass), user_data : Pointer(Void)) : Nil
        end

        # :nodoc:
        def self._instance_init(instance : Pointer(LibGObject::TypeInstance), type : Pointer(LibGObject::TypeClass)) : Nil
        end
      {% end %}
    end

    # Declares a GObject signal.
    #
    # Supported signal parameter types are:
    #
    #  - Integer types
    #  - Float types
    macro signal(signature)
      {%
        raise "signal parameter must be a signature (Macros::Call), got #{signature.class_name}" unless signature.is_a?(Call)
        raise "Signal signature #{signature} can't have a receiver" if signature.receiver
        raise "Signal signature #{signature} can't have a block argument" if signature.block_arg
      %}

      struct {{ signature.name.titleize }}Signal < GObject::Signal
        def name : String
          @detail ? "{{ signature.name }}::#{@detail}" : {{ signature.name.stringify }}
        end

        alias LeanProc = Proc({{ (signature.args.map(&.type) << Nil).splat }})

        def connect(*, after : Bool = false, &block : LeanProc) : GObject::SignalConnection
          connect(block, after: after)
        end

        def connect(handler : LeanProc, *, after : Bool = false) : GObject::SignalConnection
          _box = ::Box.box(handler)
          {% if signature.args.empty? %}
          handler = ->(_lib_sender : Pointer(Void), _lib_box : Pointer(Void)) { ::Box(LeanProc).unbox(_lib_box).call }.pointer
          {% else %}
          handler = ->(_lib_sender : Pointer(Void),
          {% for arg in signature.args %}
          {%
            resolved_type = arg.type.resolve
            if resolved_type == String
              type = ::Pointer(UInt8)
            elsif resolved_type == Bool
              type = ::Int32
            else
              type = arg.type
            end
          %}
          {{ arg.var }} : {{ type }},
          {% end %}
          _lib_box : Pointer(Void)) {

            {% for arg in signature.args %}
            {% resolved_type = arg.type.resolve %}
            {% if arg.type.resolve == String %}
              {{ arg.var }} = String.new({{ arg.var }})
            {% elsif arg.type.resolve == Bool %}
              {{ arg.var }} = {{ arg.var }} != 0
            {% end %}
            {% end %}

            ::Box(LeanProc).unbox(_lib_box).call({{ signature.args.map(&.var).splat }})
          }.pointer
          {% end %}

          handler = LibGObject.g_signal_connect_data(@source, name, handler,
            GICrystal::ClosureDataManager.register(_box), ->GICrystal::ClosureDataManager.deregister, after.to_unsafe)
          GObject::SignalConnection.new(@source, handler)
        end

        def emit({{ signature.args.splat }})
          LibGObject.g_signal_emit_by_name(@source, {{ signature.name.stringify }}, {{ signature.args.map(&.var).splat }})
        end
      end

      def {{ signature.name }}_signal
        {{ signature.name.titleize }}Signal.new(self)
      end

      def self._class_init(klass : Pointer(LibGObject::TypeClass), user_data : Pointer(Void)) : Nil
        LibGObject.g_signal_new({{ signature.name.stringify }}, g_type,
        GObject::SignalFlags.flags(RunLast, NoRecurse, NoHooks),
        0,                   # class_offset
        Pointer(Void).null,  # accumulator
        Pointer(Void).null,  # accumulator_data
        Pointer(Void).null,  # marshaller
        GObject::TYPE_NONE,  # return_type
        {{ signature.args.size }}, # n_params
        {% for arg in signature.args %}
        {{ arg.type }}.g_type,
        {% end %}
        Pointer(Void).null)
        previous_def
      end
    end
  end
end
