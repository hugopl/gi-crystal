module GObject
  # Virtual functions must be annotated with this.
  #
  # The annotation supports the following attributes:
  #
  # - unsafe: true/false.
  # - name: The name of the virtual function, if not present it's guessed from methods name.
  #
  # All the method declaration bellow are equivalent and implement the _snapshot_ virtual method.
  #
  # ```Crystal
  # @[GObject::Virtual]
  # def do_snapshot(snapshot : Gtk::Snapshot)
  # end
  #
  # @[GObject::Virtual]
  # def snapshot(snapshot : Gtk::Snapshot)
  # end
  #
  # @[GObject::Virtual(name: "snapshot")]
  # def heyho(snapshot : Gtk::Snapshot)
  # end
  # ```
  #
  # If for some reason you want to go bare metal and not have any wrappers involved in your virtual method implementation
  # you can use the *unsafe* annotation flag, then the implementation will receive the pointers for the Objects and structs
  # instead of GI::Crystal wrappers. It's up to you to handle the memory and reference count.
  #
  # ```Crystal
  # @[GObject::Virtual(unsafe: true)]
  # def snapshot(snapshot : Pointer(Void))
  # end
  # ```
  annotation Virtual
  end

  class Object
    macro inherited
      {% unless @type.annotation(GICrystal::GeneratedWrapper) %}
        macro method_added(method)
          {% verbatim do %}
            {% if method.annotation(GObject::Virtual) %}
              {% vfunc_name = method.annotation(GObject::Virtual)[:name] || method.name.gsub(/^do_/, "") %}
              {% if method.annotation(GObject::Virtual)[:unsafe] %}
                {% vfunc_name = "unsafe_#{vfunc_name.id}" %}
              {% end %}
              _register_{{ vfunc_name.id }}_vfunc
            {% end %}
          {% end %}
        end

        # GType for the new created type
        @@_g_type : UInt64 = 0

        def self.g_type : UInt64
          if LibGLib.g_once_init_enter(pointerof(@@_g_type)) != 0
            g_type = {{ @type.superclass.id }}._register_derived_type("{{ @type.name.gsub(/::/, "-") }}",
              ->_class_init(Pointer(LibGObject::TypeClass), Pointer(Void)),
              ->_instance_init(Pointer(LibGObject::TypeInstance), Pointer(LibGObject::TypeClass)))

            LibGLib.g_once_init_leave(pointerof(@@_g_type), g_type)
            self._install_ifaces
          end

          @@_g_type
        end

        # :nodoc:
        def self._class_init(klass : Pointer(LibGObject::TypeClass), user_data : Pointer(Void)) : Nil
        end

        # :nodoc:
        def self._instance_init(instance : Pointer(LibGObject::TypeInstance), type : Pointer(LibGObject::TypeClass)) : Nil
        end

        # :nodoc:
        def self._install_ifaces
          {% verbatim do %}
            {% for ancestor in @type.ancestors.uniq %}
              {% if ancestor.module? && ancestor.class.has_method?("g_type") %}
                closure = ->_install_iface_{{ ancestor.name.gsub(/::/, "__") }}(Pointer(LibGObject::TypeInterface))
                interface_info = LibGObject::InterfaceInfo.new()
                interface_info.interface_init = closure.pointer
                interface_info.interface_finalize = Pointer(Void).null
                interface_info.interface_data = closure.closure_data
                LibGObject.g_type_add_interface_static(g_type, {{ ancestor }}.g_type, pointerof(interface_info))
              {% end %}
            {% end %}
          {% end %}
        end

        # Cast a `GObject::Object` to this type, returns nil if cast can't be made.
        def self.cast?(obj : GObject::Object) : self?
          return if LibGObject.g_type_check_instance_is_a(obj, g_type).zero?

          # If the object was collected by Crystal GC but still alive in C world we can't bring
          # the crystal object form the dead.
          gc_collected = GICrystal.gc_collected?(obj)
          instance = GICrystal.instance_pointer(obj)
          raise GICrystal::ObjectCollectedError.new if gc_collected || instance.null?

          instance.as(self)
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

    def initialize
      @pointer = LibGObject.g_object_newv(self.class.g_type, 0, Pointer(Void).null)
      LibGObject.g_object_ref_sink(self) if LibGObject.g_object_is_floating(self) == 1
      LibGObject.g_object_set_qdata(self, GICrystal::INSTANCE_QDATA_KEY, Pointer(Void).new(object_id))
    end

    def initialize(pointer, transfer : GICrystal::Transfer)
      @pointer = pointer
      LibGObject.g_object_ref_sink(self) if transfer.none? || LibGObject.g_object_is_floating(self) == 1
    end

    # Returns GObject reference counter.
    def ref_count : UInt32
      to_unsafe.as(Pointer(LibGObject::Object)).value.ref_count
    end

    # Cast a `GObject::Object` to `self`, throws a `TypeCastError` if the cast can't be made.
    def self.cast(obj : GObject::Object) : self
      cast?(obj) || raise TypeCastError.new("can't cast #{typeof(obj).name} to #{self}")
    end

    # Cast a `GObject::Object` to `self`, returns nil if the cast can't be made.
    def self.cast?(obj : GObject::Object) : self?
      new(obj.to_unsafe, GICrystal::Transfer::None) unless LibGObject.g_type_check_instance_is_a(obj, g_type).zero?
    end
  end
end
