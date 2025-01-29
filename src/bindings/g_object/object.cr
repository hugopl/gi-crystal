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

  # This annotation install a Crystal property as a GObject property, so it can be recognized by GObject
  #
  # It accepts the following parameters:
  #
  # name: Canonical name of the property specified, default to the variable name.
  # nick: Nick name for the property specified, default to nil.
  # default: The default value for this property when created from C world (impossible at the moment).
  # min: Minimum value for this property, only valid for numeric or Char properties.
  # max: Maximum value for this property, only valid for numeric or Char properties.
  # blurb: Description of the property specified, default to nil.
  #
  # Example:
  # ```Crystal
  # private class PropObject < GObject::Object
  #   @[GObject::Property(nick: "INTEGER", blurb: "An Int32", default: 42, min: 40, max: 50)]
  #   property int : Int32 = 42
  #
  #   def initialize
  #     super()
  #   end
  # end
  # ```
  annotation Property
  end

  class Object
    macro inherited
      # :nodoc
      def self._create_obj_through_default_constructor : Pointer(Void)
        LibGLib.g_log("GICrystal", 4,
                      {{ "Tried to create an instance of #{@type} from C, but #{@type} doesn't have a default constructor." }})
        Pointer(Void).null
      end

      {% unless @type.annotation(GICrystal::GeneratedWrapper) %}
        macro method_added(method)
          {% verbatim do %}
            {% if method.annotation(GObject::Virtual) %}
              {% vfunc_name = method.annotation(GObject::Virtual)[:name] || method.name.gsub(/^do_/, "") %}
              {% if method.annotation(GObject::Virtual)[:unsafe] %}
                {% vfunc_name = "unsafe_#{vfunc_name.id}" %}
              {% end %}
              _register_{{ vfunc_name.id }}_vfunc({{ method.name }})
            {% end %}

            {% if method.name == "initialize" && (method.args.empty? || method.args.all?(&.default_value)) %}
              # :nodoc
              def self._create_obj_through_default_constructor : Pointer(Void)
                {{ @type }}.new.as(Void*)
              end
            {% end %}
          {% end %}
        end

        # GType for the new created type
        @@_g_type : UInt64 = 0

        # ParamSpec pointers for the GObject properties in the object
        @@_g_param_specs = Pointer(LibGObject::ParamSpec*).null

        @_g_retainer : Void* = Pointer(Void).null

        def self.g_type : UInt64
          if LibGLib.g_once_init_enter(pointerof(@@_g_type)) != 0
            g_type = {{ @type.superclass.id }}._register_derived_type("{{ @type.name.gsub(/::/, "-") }}",
              ->_class_init(Pointer(LibGObject::TypeClass), Pointer(Void)),
              ->_instance_init(Pointer(LibGObject::TypeInstance), Pointer(LibGObject::TypeClass)),
              {% if @type.abstract? %}
              GObject::TypeFlags::Abstract,
              {% end %}
              )
            LibGLib.g_once_init_leave(pointerof(@@_g_type), g_type)

            {% unless @type.abstract? %}
              ctor = ->_create_obj_through_default_constructor
              LibGObject.g_type_set_qdata(g_type, GICrystal::INSTANCE_USERTYPE_FACTORY, ctor.pointer)
            {% end %}
            self._install_ifaces
          end

          @@_g_type
        end

        # :nodoc:
        def self._class_init(klass : Pointer(LibGObject::TypeClass), user_data : Pointer(Void)) : Nil
          {% verbatim do %}
            {% begin %}
              {% instance_vars = @type.instance_vars.select(&.annotation(GObject::Property)) %}

              @@_g_param_specs = Pointer(LibGObject::ParamSpec*).malloc({{ instance_vars.size }})
              {% for var, i in instance_vars %}
                {% property = var.annotation(GObject::Property) %}
                name = {{ var.name.gsub(/\_/, "-").stringify }}.to_unsafe
                nick = {{ property["nick"] }}.try(&.to_unsafe) || Pointer(LibC::Char).null
                blurb = {{ property["blurb"] }}.try(&.to_unsafe) || Pointer(LibC::Char).null

                {% has_getter = @type.has_method?(var.name.stringify) || @type.has_method?(var.name.stringify + "?") %}
                {% has_setter = @type.has_method?("#{var.name}=") %}
                {% raise "GObject properties need to have a getter and/or a setter" unless has_getter || has_setter %}

                flags = GObject::ParamFlags::StaticName | GObject::ParamFlags::StaticBlurb | GObject::ParamFlags::ExplicitNotify
                flags |= GObject::ParamFlags::Deprecated unless {{ !!var.annotation(Deprecated) }}
                flags |= GObject::ParamFlags::Readable if {{ has_getter }}
                flags |= GObject::ParamFlags::Writable if {{ has_setter }}

                {% other_args = property.named_args.to_a.select { |arg| %w(min max default).includes?(arg[0].stringify) } %}
                # Finally register the type to GLib.
                # The given varible name has its underscores converted to dashes.
                pspec = GObject.create_param_spec({{ var.type }}, name, nick, blurb, flags, {{ other_args.map { |tuple| "#{tuple[0]}: #{tuple[1]}".id }.splat }})
                @@_g_param_specs[{{ i }}] = pspec.as(LibGObject::ParamSpec*)
                LibGObject.g_object_class_install_property(klass, {{ i + 1 }}, pspec)
              {% end %}
            {% end %}
          {% end %}
        end

        # :nodoc:
        #
        # GObject instance initialization, creates the Crystal instance if there's no one created yet.
        def self._instance_init(instance : Pointer(LibGObject::TypeInstance), type : Pointer(LibGObject::TypeClass)) : Nil
          # Return if the Crystal instance is already set up.
          crystal_instance = LibGObject.g_object_get_qdata(instance, GICrystal::INSTANCE_QDATA_KEY)
          return if crystal_instance

          # Check if this was called from a Crystal constructor
          crystal_instance = GICrystal.crystal_object_being_created
          # If not, this comes from a C call, so a Crystal instance needs to be created, however
          {% unless @type.abstract? %}
            crystal_instance ||= GICrystal.create_user_type_from_c_instance(instance, type)
          {% end %}

          # Now we have a Crystal object instance, let's set it up:
          # - Set the INSTANCE_QDATA_KEY, so if someone read a property the get_property callback can
          #   know what's the Crystal instance.
          # - Set the Crystal instance @pointer variable, so Crystal code can run without a dangling pointer.
          if crystal_instance
            crystal_instance.as(GObject::Object)._gobj_pointer = instance.as(Void*)
            LibGObject.g_object_set_qdata(instance, GICrystal::INSTANCE_QDATA_KEY, crystal_instance)
            GICrystal.crystal_object_being_created = Pointer(Void).null
          end
        end

        # :nodoc:
        def self._g_toggle_notify(object : Void*, _gobject : Void*, is_last_ref : Int32) : Nil
          return if object.null?
          is_last_ref = GICrystal.to_bool(is_last_ref)

          if is_last_ref
            # This branch is entered once there are no additional references to this GObject left.
            # Remove the toggle ref so it can be garbage collected if there are no references to this object in crystal.

            GICrystal::ToggleRefManager.deregister(object.as(self).@_g_retainer)
          else
            # This branch is entered once at least one additional reference to this GObject has been established.
            # It must now be protected from being garbage collected.

            (object + offsetof(self, @_g_retainer)).as(Void**).value = GICrystal::ToggleRefManager.register(object)
          end
        end
        private G_TOGGLE_NOTIFY__ = ->_g_toggle_notify(Void*, Void*, Int32)

        # :nodoc:
        @[GObject::Virtual(unsafe: true, name: "get_property")]
        def _get_property(property_id : UInt32, gvalue : Void*, param_spec : Void*) : Nil
          {% verbatim do %}
            {% begin %}
              {% instance_vars = @type.instance_vars.select(&.annotation(GObject::Property)) %}

              case property_id
              {% for var, i in instance_vars %}
                {% if @type.has_method?(var.name.stringify) %}
                  when {{ i + 1 }}
                    GObject::Value.set_g_value(gvalue.as(LibGObject::Value*), self.{{ var }})
                {% end %}
              {% end %}
              end
            {% end %}
          {% end %}
        end

        # :nodoc:
        @[GObject::Virtual(unsafe: true, name: "set_property")]
        def _set_property(property_id : UInt32, gvalue : Void*, param_spec : Void*) : Nil
          {% verbatim do %}
            {% begin %}
              {% instance_vars = @type.instance_vars.select(&.annotation(GObject::Property)) %}

              case property_id
              {% for var, i in instance_vars %}
                {% if @type.has_method?("#{var.name}=") %}
                  when {{ i + 1 }}
                    {% if var.type.nilable? && var.type.union_types.size > 2 %}
                      {% raise "Union types are not supported in GObject properties" %}
                    {% end %}

                    {% var_type = var.type.union_types.reject { |t| t == Nil }.first %}

                    {% if var_type < GObject::Object %}
                      raw = GObject::Value.raw(GObject::TYPE_OBJECT, gvalue)
                      {% if var.type.nilable? %}
                        raw_obj = raw.as?(GObject::Object)
                        self.{{ var }} = raw_obj.nil? ? nil : {{ var_type }}.cast(raw_obj)
                      {% else %}
                        self.{{ var }} = {{ var_type }}.cast(raw.as(GObject::Object))
                      {% end %}
                    {% elsif var_type < Enum %}
                      {% if var_type.annotation(Flags) %}
                        raw = GObject::Value.raw(GObject::TYPE_FLAGS, gvalue)
                        self.{{ var }} = raw.as(UInt32).unsafe_as({{ var_type }})
                      {% else %}
                        raw = GObject::Value.raw(GObject::TYPE_ENUM, gvalue)
                        self.{{ var }} = raw.as(Int32).unsafe_as({{ var_type }})
                      {% end %}
                    {% else %}
                      raw = GObject::Value.raw({{ var_type }}.g_type, gvalue)
                      self.{{ var }} = raw.as({{ var_type }})
                    {% end %}
                {% end %}
              {% end %}
              end
            {% end %}
          {% end %}
        end

        private macro _emit_notify_signal(arg)
          {% verbatim do %}
            {% begin %}
              {% instance_vars = @type.instance_vars.select(&.annotation(GObject::Property)) %}

              {% for var, i in instance_vars %}
                {% if var.name == arg.id %}
                  LibGObject.g_object_notify_by_pspec(self, @@_g_param_specs[{{ i }}])
                {% end %}
              {% end %}
            {% end %}
          {% end %}
        end

        # :nodoc:
        # Mostly copied from crystal source
        macro setter(*names)
          {% verbatim do %}
            {% for name in names %}
              {% if name.is_a?(TypeDeclaration) %}
                @{{name}}

                def {{name.var.id}}=(@{{name.var.id}} : {{name.type}})
                  _emit_notify_signal({{name.var.id}})
                end
              {% elsif name.is_a?(Assign) %}
                @{{name}}

                def {{name.target.id}}=(@{{name.target.id}})
                  _emit_notify_signal({{name.target.id}})
                end
              {% else %}
                def {{name.id}}=(@{{name.id}})
                  _emit_notify_signal({{name.id}})
                end
              {% end %}
            {% end %}
          {% end %}
        end

        # :nodoc:
        # Mostly copied from crystal source
        macro property(*names, &block)
          {% verbatim do %}
            {% if block %}
              {% if names.size != 1 %}
                {{ raise "Only one argument can be passed to `property` with a block" }}
              {% end %}

              {% name = names[0] %}

              {% if name.is_a?(TypeDeclaration) %}
                @{{name.var.id}} : {{name.type}}?

                def {{name.var.id}} : {{name.type}}
                  if (value = @{{name.var.id}}).nil?
                    @{{name.var.id}} = {{yield}}
                    _emit_notify_signal({{name.var.id}})
                  else
                    value
                  end
                end

                def {{name.var.id}}=(@{{name.var.id}} : {{name.type}})
                  _emit_notify_signal({{name.var.id}})
                end
              {% else %}
                def {{name.id}}
                  if (value = @{{name.id}}).nil?
                    @{{name.id}} = {{yield}}
                    _emit_notify_signal({{name.id}})
                  else
                    value
                  end
                end

                def {{name.id}}=(@{{name.id}})
                  _emit_notify_signal({{name.id}})
                end
              {% end %}
            {% else %}
              {% for name in names %}
                {% if name.is_a?(TypeDeclaration) %}
                  @{{name}}

                  def {{name.var.id}} : {{name.type}}
                    @{{name.var.id}}
                  end

                  def {{name.var.id}}=(@{{name.var.id}} : {{name.type}})
                    _emit_notify_signal({{name.var.id}})
                  end
                {% elsif name.is_a?(Assign) %}
                  @{{name}}

                  def {{name.target.id}}
                    @{{name.target.id}}
                  end

                  def {{name.target.id}}=(@{{name.target.id}})
                    _emit_notify_signal({{name.target.id}})
                  end
                {% else %}
                  def {{name.id}}
                    @{{name.id}}
                  end

                  def {{name.id}}=(@{{name.id}})
                    _emit_notify_signal({{name.id}})
                  end
                {% end %}
              {% end %}
            {% end %}
          {% end %}
        end

        # :nodoc:
        # Mostly copied from crystal source
        macro property!(*names)
          {% verbatim do %}
            getter! {{names.splat}}

            {% for name in names %}
              {% if name.is_a?(TypeDeclaration) %}
                def {{name.var.id}}=(@{{name.var.id}} : {{name.type}})
                  _emit_notify_signal({{name.var.id}})
                end
              {% else %}
                def {{name.id}}=(@{{name.id}})
                  _emit_notify_signal({{name.id}})
                end
              {% end %}
            {% end %}
          {% end %}
        end

        # :nodoc:
        # Mostly copied from crystal source
        macro property?(*names, &block)
          {% verbatim do %}
            {% if block %}
              {% if names.size != 1 %}
                {{ raise "Only one argument can be passed to `property?` with a block" }}
              {% end %}

              {% name = names[0] %}

              {% if name.is_a?(TypeDeclaration) %}
                @{{name.var.id}} : {{name.type}}?

                def {{name.var.id}} : {{name.type}}
                  if (value = @{{name.var.id}}).nil?
                    @{{name.var.id}} = {{yield}}
                    _emit_notify_signal({{name.var.id}})
                  else
                    value
                  end
                end

                def {{name.var.id}}? : {{name.type}}
                  if (value = @{{name.var.id}}).nil?
                    @{{name.var.id}} = {{yield}}
                    _emit_notify_signal({{name.var.id}})
                  else
                    value
                  end
                end

                def {{name.var.id}}=(@{{name.var.id}} : {{name.type}})
                  _emit_notify_signal({{name.var.id}})
                end
              {% else %}
                def {{name.id}}
                  if (value = @{{name.id}}).nil?
                    @{{name.id}} = {{yield}}
                    _emit_notify_signal({{name.id}})
                  else
                    value
                  end
                end

                def {{name.id}}?
                  if (value = @{{name.id}}).nil?
                    @{{name.id}} = {{yield}}
                    _emit_notify_signal({{name.id}})
                  else
                    value
                  end
                end

                def {{name.id}}=(@{{name.id}})
                  _emit_notify_signal({{name.id}})
                end
              {% end %}
            {% else %}
              {% for name in names %}
                {% if name.is_a?(TypeDeclaration) %}
                  @{{name}}

                  def {{name.var.id}} : {{name.type}}
                    @{{name.var.id}}
                  end

                  def {{name.var.id}}? : {{name.type}}
                    @{{name.var.id}}
                  end

                  def {{name.var.id}}=(@{{name.var.id}} : {{name.type}})
                    _emit_notify_signal({{name.var.id}})
                  end
                {% elsif name.is_a?(Assign) %}
                  @{{name}}

                  def {{name.target.id}}
                    @{{name.target.id}}
                  end

                  def {{name.target.id}}?
                    @{{name.target.id}}
                  end

                  def {{name.target.id}}=(@{{name.target.id}})
                    _emit_notify_signal({{name.target.id}})
                  end
                {% else %}
                  def {{name.id}}
                    @{{name.id}}
                  end

                  def {{name.id}}?
                    @{{name.id}}
                  end

                  def {{name.id}}=(@{{name.id}})
                    _emit_notify_signal({{name.id}})
                  end
                {% end %}
              {% end %}
            {% end %}
          {% end %}
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
          new(obj.to_unsafe, :none) unless LibGObject.g_type_check_instance_is_a(obj, g_type).zero?
        end

        # A hook to be executed after the underlying gobject has been initialized.
        #
        # This specific implementation turns a normal reference into a toggle reference.
        private def _after_init : Nil
          # Set toggle ref to protect the crystal object from the garbage collector while in C.
          self.class._g_toggle_notify(self.as(Void*), @pointer, 0)
          LibGObject.g_object_add_toggle_ref(@pointer, G_TOGGLE_NOTIFY__, self.as(Void*))
          LibGObject.g_object_unref(@pointer)
        end

        # :nodoc:
        def finalize
          {% if flag?(:debugmemory) %}
            LibC.printf("~%s at %p - ref count: %d\n", self.class.name.to_unsafe, self, ref_count)
          {% end %}

          LibGObject.g_object_set_qdata(self, GICrystal::INSTANCE_QDATA_KEY, Pointer(Void).null)
          LibGObject.g_object_remove_toggle_ref(self, G_TOGGLE_NOTIFY__, self.as(Void*))
        end

        # :nodoc:
        def self.new(pointer, transfer : GICrystal::Transfer) : self
          # This overrides the `initialize(pointer, transfer : GICrystal::Transfer)`
          # method because we must make sure there is never a second crystal object for this gobject.

          instance = LibGObject.g_object_get_qdata(pointer, GICrystal::INSTANCE_QDATA_KEY)
          raise "Could not retrieve crystal instance!" if instance.null?

          LibGObject.g_object_ref_sink(pointer) if transfer.none? || LibGObject.g_object_is_floating(pointer) == 1
          LibGObject.g_object_unref(pointer)

          instance.as(self)
        end
      {% end %}
    end

    # To be used inside a vfunc (re)-implementation. Has the same meaning of `super`, but works with GObject virtual functions.
    #
    # Do nothing is the current vfunc doesn't have any previous implementation.
    macro previous_vfunc(*args)
      \{% begin %}
        %func = @@_gi_parent_vfunc_\{{ (@def.annotation(GObject::Virtual)[:name] || @def.name.gsub(/^do_/, "")).id }}
        {% if args.empty? %}
          %func.try &.call(self.to_unsafe, \{{ @def.args.map { |arg| arg.internal_name || arg.name }.splat }})
        {% else %}
          %func.try &.call(self.to_unsafe, {{ args.splat }})
        {% end %}
      \{% end %}
    end

    # To be used inside a vfunc (re)-implementation. Has the same meaning of `super`, but works with GObject virtual functions.
    #
    # Raises NilAssertionError if the current vfunc doesn't have any previous implementation.
    macro previous_vfunc!(*args)
      \{% begin %}
        %func = @@_gi_parent_vfunc_\{{ (@def.annotation(GObject::Virtual)[:name] || @def.name.gsub(/^do_/, "")).id }}.not_nil!
        {% if args.empty? %}
          %func.call(self.to_unsafe, \{{ @def.args.map { |arg| arg.internal_name || arg.name }.splat }})
        {% else %}
          %func.call(self.to_unsafe, {{ args.splat }})
        {% end %}
      \{% end %}
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

      struct {{ signature.name.camelcase }}Signal < GObject::Signal
        def name : String
          @detail ? "{{ signature.name }}::#{@detail}" : {{ signature.name.stringify }}
        end

        alias LeanProc = Proc({{ (signature.args.map(&.type) << Nil).splat }})

        def validate_params(
          {% for arg in signature.args %}
            {{ arg }}.class,
          {% end %}
          )
        end

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
            if resolved_type == String || resolved_type == Path
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
            {% if resolved_type == String %}
              {{ arg.var }} = String.new({{ arg.var }})
            {% elsif resolved_type == Path %}
              {{ arg.var }} = Path.new(String.new({{ arg.var }}))
            {% elsif resolved_type == Bool %}
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
        {{ signature.name.camelcase }}Signal.new(self)
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
      GICrystal.crystal_object_being_created = Pointer(Void).new(object_id)

      g_object = GICrystal.g_object_being_created
      @pointer = g_object || LibGObject.g_object_newv(self.class.g_type, 0, Pointer(LibGObject::Parameter).null)
      GICrystal.g_object_being_created = Pointer(Void).null

      # If object is created by C, the qdata was already set.
      LibGObject.g_object_set_qdata(self, GICrystal::INSTANCE_QDATA_KEY, self.as(Void*)) unless g_object
      LibGObject.g_object_ref_sink(self) if LibGObject.g_object_is_floating(self) == 1

      self._after_init
    end

    def initialize(pointer, transfer : GICrystal::Transfer)
      @pointer = pointer
      LibGObject.g_object_ref_sink(self) if transfer.none? || LibGObject.g_object_is_floating(self) == 1
      self._after_init
    end

    # :nodoc:
    # Set the internal GObject pointer.
    #
    # When creating crystal objects using property constructors that set Crystal properties we must
    # set the @pointer in the GObject instance_init method, because at this point the Crystal instance
    # was already created but is inside a call of `g_object_new_with_properties` and would only set the
    # @pointer after it returns, however the @pointer is needed to write the properties.
    def _gobj_pointer=(@pointer)
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
      new(obj.to_unsafe, :none) unless LibGObject.g_type_check_instance_is_a(obj, g_type).zero?
    end
  end
end
