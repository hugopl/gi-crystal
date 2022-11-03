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

  annotation Property
  end

  # :nodoc:
  annotation RefProp
  end

  # :nodoc:
  annotation HiddenMethod
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
              _register_{{ vfunc_name.id }}_vfunc({{ method.name }})
            {% end %}
            {% if method.name == "initialize" %}
              {% raise "GObject initialize method must be private!" unless method.visibility == :private %}
              {% raise "GObject initialize method must accept block!" unless method.accepts_block? %}
              {% raise "GObject initialize method cannot have a double splat argument!" if method.double_splat %}
              {% raise "GObject initialize method cannot have a splat argument!" if method.splat_index && method.args[method.splat_index].name != "" %}
              {% raise "GObject initialize method arguments must have restrictions!" if method.args.any? { |arg| !arg.restriction && arg.name != "" } %}

              {% if !method.args.empty? %}
                struct GI_INITIALIZE_ARGS
                  {% for arg in method.args.reject { |arg| arg.name == "" } %}
                    property {{arg.name}} : {{arg.restriction}} = nil.unsafe_as({{arg.restriction}})
                    {% if arg.annotation(GObject::RefProp) %}
                      property _gi_set_{{arg.name}} : Bool = false
                    {% end %}
                  {% end %}
                end

                @_gi_initialize_args : Void* = Pointer(Void).null
              {% end %}
            {% end %}
          {% end %}
        end

        macro finished
          {% verbatim do %}
            {% initialize_candidates = @type.methods.select { |method| method.name == "initialize" } %}
            {% raise "GObject subclasses cannot have multiple initialize methods, use self.new instead" unless initialize_candidates.size <= 1 %}
          {% end %}
        end

        # :nodoc:
        protected def self.new_from_params(**args : **ARGS) forall ARGS
          {% verbatim do %}
            {% begin %}
              {% initialize = @type.methods.find { |method| method.name == "initialize" } %}
              {% if initialize %}
                {% construct_only_properties = initialize.args %}
                {% construct_only_properties_keys = construct_only_properties.map { |prop| prop.name } %}
                {% construct_only_properties_splat_index = initialize.splat_index %}
              {% else %}
                {% construct_only_properties = construct_only_properties_keys = [] of String %}
                {% construct_only_properties_splat_index = nil %}
              {% end %}

              {% crystal_properties = @type.instance_vars.select { |var| var.annotation(GObject::Property) && @type.has_method?(var.name.stringify + "=") } %}
              {% crystal_properties_keys = crystal_properties.map { |prop| prop.name } %}

              {% c_type_properties = @type.constant("C_TYPE_PROPERTIES").resolve %}
              {% c_type_properties_keys = c_type_properties.map { |prop| prop["identifier"].id } %}

              {% all_keys = (construct_only_properties_keys + crystal_properties_keys + c_type_properties_keys) %}

              {% error = false %}

              # Check for unused keys
              {% error = true unless (ARGS.keys.reject { |key| all_keys.includes?(key) }).empty? %}

              _names = uninitialized Pointer(LibC::Char)[{{ ARGS.size }}]
              _values = StaticArray(LibGObject::Value, {{ ARGS.size }}).new(LibGObject::Value.new)
              _n = 0

              # Handle properties of last non-crystal superclass
              {% for prop in c_type_properties %}
                {% error = true if ARGS[prop["identifier"].id] && !(ARGS[prop["identifier"].id] <= prop["type"].resolve) %}
                if args.has_key?({{ prop["identifier"] }}) && !args[{{ prop["identifier"] }}]?.nil?
                  (_names.to_unsafe + _n).value = {{ prop["name"] }}.to_unsafe
                  GObject::Value.init_g_value(_values.to_unsafe + _n, args[{{ prop["identifier"] }}]?.not_nil!)
                  _n += 1
                end
              {% end %}

              # Handle GObject properties defined in crystal
              {% for prop in crystal_properties %}
                {% error = true if ARGS[prop.name] && !(ARGS[prop.name] <= prop.type) %}
                if args.has_key?({{ prop.name.stringify }}) && !args[{{ prop.name.stringify }}]?.nil?
                  (_names.to_unsafe + _n).value = {{ prop.name.gsub(/\_/, "-").stringify }}.to_unsafe
                  GObject::Value.init_g_value(_values.to_unsafe + _n, args[{{ prop.name.stringify }}]?.not_nil!)
                  _n += 1
                end
              {% end %}

              # Handle GObject construct-only properties
              {% for prop in construct_only_properties.reject { |prop| prop.name == "" } %}
                {% error = true if (ARGS[prop.name] && !(ARGS[prop.name] <= prop.restriction.resolve)) || (!prop.default_value && !ARGS[prop.name]) %}
                if args.has_key?({{ prop.name.stringify }}) && !args[{{ prop.name.stringify }}]?.nil?
                  {% if prop.annotation(GObject::RefProp) %}
                    valueof_{{ prop.name.id }} : {{ prop.restriction }} = args[{{ prop.name.stringify }}]?.as({{prop.restriction}})
                    (_names.to_unsafe + _n).value = {{ prop.name.gsub(/\_/, "-").stringify }}.to_unsafe
                    GObject::Value.init_g_value(_values.to_unsafe + _n, pointerof(valueof_{{ prop.name.id }}).as(Void*))
                  {% else %}
                    (_names.to_unsafe + _n).value = {{ prop.name.gsub(/\_/, "-").stringify }}.to_unsafe
                    GObject::Value.init_g_value(_values.to_unsafe + _n, args[{{ prop.name.stringify }}]?.not_nil!)
                  {% end %}
                  _n += 1
                end
              {% end %}

              # Show "no overload matches" error replica if there are unused variables or type mismatches
              {%
                if error
                  other_overloads = @type.class.methods.select { |method| method.name == "new" && method.visibility == :public && method != @def && !method.annotation(GObject::HiddenMethod) }
                  c_type_properties_args = c_type_properties.map { |prop| "#{prop["identifier"].id} : #{(prop["type"].resolve.union_types.reject { |type| type == Nil }.sort_by(&.name) << Nil).join(" | ").id} = nil".id }
                  crystal_properties_args = crystal_properties.map { |prop| "#{prop.name} : #{(prop.type.union_types.reject { |type| type == Nil }.sort_by(&.name) << Nil).join(" | ").id} = nil".id }
                  construct_only_properties_args = construct_only_properties.map do |prop|
                    if prop.name == ""
                      "*".id
                    else
                      if prop.default_value
                        "#{prop.name} : #{(prop.restriction.resolve.union_types.reject { |type| type == Nil }.sort_by(&.name) << Nil).join(" | ").id} = nil".id
                      else
                        "#{prop.name} : #{prop.restriction.resolve.union_types.sort_by { |arg| arg.name == "Nil" ? "~" : arg.name }.join(" | ").id}".id
                      end
                    end
                  end
                  all_args = construct_only_properties_args + crystal_properties_args + c_type_properties_args

                  raise "no overload matches '#{@type}.new', #{ARGS.keys.map { |key| "#{key}: #{ARGS[key]}".id }.splat}\
                      \n Overloads are:\
                      \n - #{@type}.new(#{"*, ".id unless all_args.empty? || construct_only_properties_splat_index}#{all_args.splat})\
                      \n #{other_overloads.map { |method| method.id.lines.first.gsub(/^def self/, " - #{@type}") }.join("\n").id}"
                end
              %}

              ptr = LibGObject.g_object_new_with_properties(self.g_type, _n, _names, _values)
              ret = self.new(ptr, :full)

              _n.times do |i|
                LibGObject.g_value_unset(_values.to_unsafe + i)
              end

              ret
            {% end %}
          {% end %}
        end

        # :nodoc:
        C_TYPE_PROPERTIES = {{ @type.superclass }}::C_TYPE_PROPERTIES

        # GType for the new created type
        @@_g_type : UInt64 = 0

        # ParamSpec pointers for the GObject properties in the object
        @@_g_param_specs = Pointer(LibGObject::ParamSpec*).null

        # A state storing the return value of ToggleRefManager.register
        @_g_retainer = Pointer(Void*).null

        # C object
        @pointer = Pointer(Void).null

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
          {% verbatim do %}
            {% begin %}
              {% initialize = @type.methods.find { |method| method.name == "initialize" } %}
              {% instance_vars = @type.instance_vars.select(&.annotation(GObject::Property)) %}

              @@_g_param_specs = Pointer(LibGObject::ParamSpec*).malloc({{ instance_vars.size + (initialize ? initialize.args.size : 0) }})
              {% for var, i in instance_vars %}
                {% property = var.annotation(GObject::Property) %}
                name = {{ var.name.gsub(/\_/, "-").stringify }}.to_unsafe
                nick = {{ property["nick"] }}.try(&.to_unsafe) || Pointer(LibC::Char).null
                blurb = {{ property["blurb"] }}.try(&.to_unsafe) || Pointer(LibC::Char).null
                default = {{ var.default_value }}
                {% other_args = property.named_args.to_a.reject { |arg| ["nick", "blurb"].includes?(arg[0].stringify) } %}

                {% has_getter = @type.has_method?(var.name.stringify) || @type.has_method?(var.name.stringify + "?") %}
                {% has_setter = @type.has_method?("#{var.name}=") %}
                {% raise "GObject properties need to have a getter and/or a setter" unless has_getter || has_setter %}

                flags = GObject::ParamFlags::StaticName | GObject::ParamFlags::StaticNick | GObject::ParamFlags::StaticBlurb | GObject::ParamFlags::ExplicitNotify
                flags |= GObject::ParamFlags::Deprecated unless {{ var.annotation(Deprecated) == nil }}
                flags |= GObject::ParamFlags::Readable if {{ has_getter }}
                flags |= GObject::ParamFlags::Writable if {{ has_setter }}
                flags |= GObject::ParamFlags::Construct if {{ var.has_default_value? && has_setter }}

                # Finally register the type to GLib.
                # The given varible name has its underscores converted to dashes.
                pspec = GObject.create_param_spec({{ var.type }}, name, nick, blurb, flags, default, {{ other_args.map { |tuple| "#{tuple[0]}: #{tuple[1]}".id }.splat }})
                @@_g_param_specs[{{ i }}] = pspec.as(LibGObject::ParamSpec*)
                LibGObject.g_object_class_install_property(klass, {{ i + 1 }}, pspec)
              {% end %}
              {% if initialize %}
                {% for arg, i in initialize.args.reject { |arg| arg.name == "" } %}
                  name = {{ arg.name.gsub(/\_/, "-").stringify }}.to_unsafe
                  nick = Pointer(LibC::Char).null
                  blurb = Pointer(LibC::Char).null
                  flags = GObject::ParamFlags::StaticName | GObject::ParamFlags::StaticNick | GObject::ParamFlags::StaticBlurb | GObject::ParamFlags::ConstructOnly | GObject::ParamFlags::Writable

                  # Finally register the type to GLib.
                  # The given varible name has its underscores converted to dashes.
                  {% if arg.annotation(GObject::RefProp) %}
                    pspec = LibGObject.g_param_spec_pointer(name, nick, blurb, flags)
                  {% else %}
                    default = {{ arg.default_value || nil }}
                    pspec = GObject.create_param_spec({{ arg.restriction }}, name, nick, blurb, flags, default)
                  {% end %}
                  @@_g_param_specs[{{ instance_vars.size + i }}] = pspec.as(LibGObject::ParamSpec*)
                  LibGObject.g_object_class_install_property(klass, {{ instance_vars.size + i + 1 }}, pspec)
                {% end %}
              {% end %}
            {% end %}
          {% end %}
        end

        # :nodoc:
        @[GObject::Virtual(unsafe: true, name: "get_property")]
        def _get_property(property_id : UInt32, gvalue : Void*, param_spec : Void*) : Nil
          {% verbatim do %}
            {% begin %}
              {% instance_vars = @type.instance_vars.select(&.annotation(GObject::Property)) %}

              case property_id
              {% for var, i in instance_vars %}
                {% if @type.has_method?(var.name.stringify + "?") %}
                  when {{ i + 1 }}
                    GObject::Value.set_g_value(gvalue.as(LibGObject::Value*), self.{{ var }}?)
                {% elsif @type.has_method?(var.name.stringify) %}
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
              {% initialize = @type.methods.find { |method| method.name == "initialize" } %}

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
                      self.{{ var }} = raw.as({{ var.type }})
                    {% end %}
                {% end %}
              {% end %}
              {% if initialize %}
                {% for arg, i in initialize.args.reject { |arg| arg.name == "" } %}
                  when {{ instance_vars.size + i + 1 }}
                    {% if arg.annotation(GObject::RefProp) %}
                      raw = GObject::Value.raw(GObject::TYPE_POINTER, gvalue)
                      raise TypeCastError.new unless raw.is_a?(Void*)
                      return if raw.as(Void*).null?
                      tmp = @_gi_initialize_args.as(GI_INITIALIZE_ARGS*).value
                      tmp.{{arg.name}} = raw.as(Void*).as(Pointer({{arg.restriction}})).value
                      tmp._gi_set_{{arg.name}} = true
                      @_gi_initialize_args.as(GI_INITIALIZE_ARGS*).value = tmp
                    {% else %}
                      {% arg_type = arg.restriction.resolve.union_types.reject { |t| t == Nil }.first %}

                      tmp = @_gi_initialize_args.as(GI_INITIALIZE_ARGS*).value
                      {% if arg_type < GObject::Object %}
                        raw = GObject::Value.raw(GObject::TYPE_OBJECT, gvalue)
                        {% if arg.type.nilable? %}
                          raw_obj = raw.as?(GObject::Object)
                          tmp.{{arg.name}} = raw_obj.nil? ? nil : {{ arg_type }}.cast(raw_obj)
                        {% else %}
                          tmp.{{arg.name}} = {{ arg_type }}.cast(raw.as(GObject::Object))
                        {% end %}
                      {% elsif arg_type < Enum %}
                        {% if arg_type.annotation(Flags) %}
                          raw = GObject::Value.raw(GObject::TYPE_FLAGS, gvalue)
                          tmp.{{arg.name}} = raw.as(UInt32).unsafe_as({{ arg_type }})
                        {% else %}
                          raw = GObject::Value.raw(GObject::TYPE_ENUM, gvalue)
                          tmp.{{arg.name}} = raw.as(Int32).unsafe_as({{ arg_type }})
                        {% end %}
                      {% else %}
                        raw = GObject::Value.raw({{ arg_type }}.g_type, gvalue)
                        tmp.{{arg.name}} = raw.as({{ arg.restriction.resolve }})
                      {% end %}
                      @_gi_initialize_args.as(GI_INITIALIZE_ARGS*).value = tmp
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

        @[GObject::Virtual(unsafe: true, name: "constructed")]
        protected def _constructed : Nil
          {% verbatim do %}
            {% begin %}
              previous_vfunc

              if @pointer.as(LibGObject::TypeInstance*).value.g_class.value.g_type == @@_g_type
                {% initialize = @type.methods.find { |method| method.name == "initialize" } %}
                {% if initialize %}
                  {% initialize_args = initialize.args.reject { |arg| arg.name == "" } %}

                  {% if !initialize_args.empty? %}
                    _gi_initialize_args = @_gi_initialize_args.as(GI_INITIALIZE_ARGS*).value

                    {% for arg in initialize_args.select { |arg| arg.annotation(GObject::RefProp) } %}
                      {% if arg.default_value %}
                        _gi_initialize_args.{{arg.name}} = {{arg.default_value}} unless _gi_initialize_args._gi_set_{{arg.name}}
                      {% else %}
                        raise ArgumentError.new("Required property {{arg.name}} was not provided during initialization") unless _gi_initialize_args._gi_set_{{arg.name}}
                      {% end %}
                    {% end %}
                  {% end %}

                  self.initialize({{ initialize_args.map { |arg| "#{arg.name}: _gi_initialize_args.#{arg.name}".id }.splat }}) {}

                  {% if !initialize_args.empty? %}
                    GC.free(@_gi_initialize_args)
                    @_gi_initialize_args = Pointer(Void).null
                  {% end %}
                {% end %}
              end
            {% end %}
          {% end %}
        end

        # :nodoc:
        def self._instance_init(instance : Pointer(LibGObject::TypeInstance), type : Pointer(LibGObject::TypeClass)) : Nil
          # This code should only be run once (protection for subclasses of crystal gobject subclasses)
          if type.value.g_type == @@_g_type
            # Allocate crystal proxy object and add toggle reference to keep it and the c object alive
            this = self.allocate
            this_ptr = this.as(Void*)
            _g_toggle_notify(pointerof(this.@_g_retainer).as(Void*), instance.as(Void*), 0)
            LibGObject.g_object_add_toggle_ref(instance, G_TOGGLE_NOTIFY__, pointerof(this.@_g_retainer).as(Void*))

            # Set @pointer and INSTANCE_QDATA
            (this_ptr + offsetof(self, @pointer)).as(Void**).value = instance.as(Void*)
            LibGObject.g_object_set_qdata(instance, GICrystal::INSTANCE_QDATA_KEY, this_ptr)

            {% verbatim do %}
              {% if (initialize = @type.methods.find { |method| method.name == "initialize" }) && !initialize.args.empty? %}
                gi_initialize_args_ptr = GC.malloc(sizeof(GI_INITIALIZE_ARGS))
                (this_ptr + offsetof(self, @_gi_initialize_args)).as(Void**).value = gi_initialize_args_ptr
              {% end %}
            {% end %}
          end
        end

        private def self._g_toggle_notify(data : Void*, _gobject : Void*, is_last_ref : Int32) : Nil
          data = data.as(Void**)
          is_last_ref = GICrystal.to_bool(is_last_ref)

          if is_last_ref
            # This crystal proxy object is the last reference to the the GObject in C-world.
            # If there are no references to this crystal object, it can be garbage collected
            return if data.value.null?
            GICrystal::ToggleRefManager.deregister(data.value)
            data.value = Pointer(Void).null
          else
            # Other references to this GObject have been established, it may not be garbage collected.
            return unless data.value.null?
            data.value = GICrystal::ToggleRefManager.register(data.as(Void*))
          end
        end
        private G_TOGGLE_NOTIFY__ = ->_g_toggle_notify(Void*, Void*, Int32)

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
          # the crystal object from the dead.
          gc_collected = GICrystal.gc_collected?(obj)
          instance = GICrystal.instance_pointer(obj)
          raise GICrystal::ObjectCollectedError.new if gc_collected || instance.null?

          instance.as(self)
        end

        def self.new(pointer, transfer : GICrystal::Transfer) : self
          instance = LibGObject.g_object_get_qdata(pointer, GICrystal::INSTANCE_QDATA_KEY)
          raise "Could not retrieve crystal instance!" if instance.null?
          LibGObject.g_object_ref_sink(pointer) if transfer.none? || LibGObject.g_object_is_floating(pointer) == 1
          LibGObject.g_object_unref(pointer) # Unref object because we still have our crystal object holding a reference
          instance.as(self)
        end

        @[GObject::HiddenMethod]
        def self.new(**args)
          new_from_params(**args)
        end

        # :nodoc:
        def finalize
          {% if flag?(:debugmemory) %}
            LibC.printf("~%s at %p - ref count: %d\n", self.class.name.to_unsafe, self, ref_count)
          {% end %}

          LibGObject.g_object_set_qdata(self, GICrystal::INSTANCE_QDATA_KEY, Pointer(Void).null)
          LibGObject.g_object_set_qdata(self, GICrystal::GC_COLLECTED_QDATA_KEY, Pointer(Void).new(0x1))
          LibGObject.g_object_remove_toggle_ref(self, G_TOGGLE_NOTIFY__, pointerof(@_g_retainer).as(Void*))
        end
      {% end %}
    end

    macro previous_vfunc(*args)
      \{% begin %}
        %func = @@_gi_parent_vfunc_\{{ (@def.annotation(GObject::Virtual)[:name] || @def.name.gsub(/^do_/, "")).id }}
        {% if args.empty? %}
          %func.try &.call(self.to_unsafe, \{{ @def.args.map { |arg| arg.internal_name || arg.name }.splat }})
        {% else %}
          %func.try &.call(self.to_unsafe, {{ *args }})
        {% end %}
      \{% end %}
    end

    macro previous_vfunc!(*args)
      \{% begin %}
        %func = @@_gi_parent_vfunc_\{{ (@def.annotation(GObject::Virtual)[:name] || @def.name.gsub(/^do_/, "")).id }}.not_nil!
        {% if args.empty? %}
          %func.call(self.to_unsafe, \{{ @def.args.map { |arg| arg.internal_name || arg.name }.splat }})
        {% else %}
          %func.call(self.to_unsafe, {{ *args }})
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

    # :nodoc:
    # Mostly copied from crystal source
    macro setter(*names)
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
    end

    # :nodoc:
    # Mostly copied from crystal source
    macro property(*names, &block)
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
    end

    # :nodoc:
    # Mostly copied from crystal source
    macro property!(*names)
      getter! {{*names}}

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
    end

    # :nodoc:
    # Mostly copied from crystal source
    macro property?(*names, &block)
      {% if block %}
        {% if names.size != 1 %}
          {{ raise "Only one argument can be passed to `property?` with a block" }}
        {% end %}

        {% name = names[0] %}

        {% if name.is_a?(TypeDeclaration) %}
          @{{name.var.id}} : {{name.type}}?

          def {{name.var.id}}? : {{name.type}}
            if (value = @{{name.var.id}}).nil?
              @{{name.var.id}} = {{yield}}
              _emit_notify_signal({{name.var.id}})
            else
              value
            end
          end

          def {{name.var.id}}=(@{{name.var.id}} : \{{name.type}})
            _emit_notify_signal({{name.var.id}})
          end
        {% else %}
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

            def {{name.var.id}}? : {{name.type}}
              @{{name.var.id}}
            end

            def {{name.var.id}}=(@{{name.var.id}} : {{name.type}})
              _emit_notify_signal({{name.var.id}})
            end
          {% elsif name.is_a?(Assign) %}
            @{{name}}

            def {{name.target.id}}?
              @{{name.target.id}}
            end

            def {{name.target.id}}=(@{{name.target.id}})
              _emit_notify_signal({{name.target.id}})
            end
          {% else %}
            def {{name.id}}?
              @{{name.id}}
            end

            def {{name.id}}=(@{{name.id}})
              _emit_notify_signal({{name.id}})
            end
          {% end %}
        {% end %}
      {% end %}
    end

    def initialize
      @pointer = LibGObject.g_object_newv(self.class.g_type, 0, Pointer(LibGObject::Parameter).null)
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
