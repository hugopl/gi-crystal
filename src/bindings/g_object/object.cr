module GObject
  # :nodoc:
  # This annotation is used to identify user types that inherit from GObject from binding types that does the same.
  annotation GeneratedWrapper
  end

  annotation PrivateDataClass
  end

  class Object
    macro inherited
      {% unless @type.annotation(GObject::GeneratedWrapper) %}
        {% if @type.annotation(GObject::PrivateDataClass) %}
          # GType for the new created type
          @@_g_type : UInt64 = 0

          # This will get overwritten by _set_pointer, but ensures the compiler does not complain
          @pointer : Pointer(Void) = Pointer(Void).null

          class ::{{ @type.superclass }}
            def self.g_type : UInt64
              {{@type}}.g_type
            end

            # :nodoc:
            def _private_instance_pointer : {{@type}}
              (@pointer + PRIVATE_INSTANCE_OFFSET).as({{@type}}*).value
            end
          end

          def self.g_type : UInt64
            if LibGLib.g_once_init_enter(pointerof(@@_g_type)) != 0
              g_type = {{ @type.superclass.superclass }}._register_derived_type({{ @type.superclass }}, _instance_size,
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
            instance_pointer = (instance.as(Void*) + PRIVATE_INSTANCE_OFFSET).as(self*)
            this = self.allocate
            instance_pointer.value = this
            this._instance_var_initializers
            this._set_pointer(instance.as(Void*))
            this.initialize()
          end

          # :nodoc:
          def self.allocate
            ptr = GC.malloc_uncollectable(instance_sizeof(self)).as(self)
            set_crystal_type_id(ptr)
            ptr
          end

          # :nodoc:
          # Normally, the allocate method sets the instance variables' default values.
          # Because the allocate method has been overwritten, this functionality has to be re-implemented.
          def _instance_var_initializers
            {% verbatim do %}
              {% for ivar in @type.instance_vars %}
                {% if ivar.has_default_value? %}
                  @{{ivar.name}} = {{ivar.default_value}}
                {% end %}
              {% end %}
            {% end %}
          end

          # :nodoc:
          # Sets the pointer
          def _set_pointer(pointer : Void*)
            @pointer = pointer
          end

          def initialize
          end

          macro inherited
            \{% raise "Cannot inherit GObject private data class" %}
          end

          # This huge macro copies the whole method signature of arbitrary methods defined in the object to the parent
          # Crystal doesn't make it easy to copy the method signature, making this rather complicated
          macro method_added(method)
            {% verbatim do %}
              class ::{{ @type.superclass }}
                {%
                  splat_index = method.splat_index
                  def_args = method.args.map_with_index do |arg, index|
                    (index == splat_index ? "*" : "") + arg.stringify + ", "
                  end.join("")
                  double_splat = method.double_splat ? "**" + method.double_splat.internal_name.stringify : ""
                  block_arg = method.block_arg ? "&" + method.block_arg.stringify : ""
                  return_type = method.return_type ? " : " + method.return_type.stringify : ""
                  free_vars = !method.free_vars.empty? ? " forall " + method.free_vars.join(",") : ""

                  call_args = method.args.map_with_index do |arg, index|
                    (index == splat_index ? "*" : "") + arg.internal_name.stringify + ", "
                  end.join("")
                %}
                # View `{{@type}}#{{method.name}}`
                def {{ method.name }}({{ def_args.id }}{{ double_splat.id }}{{ block_arg.id }}){{ return_type.id }}{{ free_vars.id }}
                  {% if method.name == "initialize" %}
                    @pointer = LibGObject.g_object_newv(self.class.g_type, 0, Pointer(Void).null)
                    LibGObject.g_object_ref_sink(self) if LibGObject.g_object_is_floating(self) == 1
                    LibGObject.g_object_set_qdata(self, GICrystal::INSTANCE_QDATA_KEY, Pointer(Void).new(object_id))
                  {% end %}

                  {% if method.name == "initialize" && method.args.size == 0 && !method.accepts_block? %}
                    # Do nothing
                  {% elsif method.accepts_block? %}
                    _private_instance_pointer.{{ method.name }}({{ call_args.id }}{{ double_splat.id }}) do |*yield_args|
                      yield *yield_args
                    end
                  {% else %}
                    _private_instance_pointer.{{ method.name }}({{ call_args.id }}{{ double_splat.id }})
                  {% end %}
                end
              end
            {% end %}
          end
        {% else %}
          private def self._complain_about_instance_vars
            \{%
              unless @type.instance_vars.size == 1
                remove_variables = @type.instance_vars
                  .map { |var| "@#{var.id}" }
                  .reject { |var| var == "@pointer" }

                raise "Cannot define instance variables in a GObject wrapper\n\
                      Please remove these variables: #{remove_variables.join(", ").id}"
              end
            %}
          end
          _complain_about_instance_vars()

          @pointer : Pointer(Void)

          # :nodoc:
          def self._instance_size : Int32
            sizeof(LIB_TYPE)
          end

          # :nodoc:
          alias LIB_TYPE = Tuple({{ @type.superclass }}::LIB_TYPE, Void*)

          # :nodoc:
          PRIVATE_INSTANCE_OFFSET = offsetof({ {{ @type.superclass }}::LIB_TYPE, Void* }, 1)
        {% end %}
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

    # Returns GObject reference counter.
    def ref_count : UInt32
      to_unsafe.as(Pointer(LibGObject::Object)).value.ref_count
    end
  end
end
