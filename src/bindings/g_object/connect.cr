require "weak_ref"

module GObject
  @[Experimental("Join discussion about this topic at https://github.com/hugopl/gi-crystal/issues/150")]
  macro connect(signal, handler)
    begin
      %box = ::Box.box(WeakRef.new(self))
      %sig = {{ signal }}
      %sig.validate_params({{ handler.args.splat }})

      # Declare "C" slot
      %c_slot = ->(sender : Void*,
        {% i = 0 %}
        {% for arg in handler.args %}
        {%
          resolved_type = arg.resolve
          if resolved_type == String || resolved_type == Path
            type = ::Pointer(UInt8)
          elsif resolved_type == Bool
            type = ::Int32
          else
            type = resolved_type
          end
        %}
          c_arg_{{ i }} : {{ type }},
        {% i += 1 %}
        {% end %}
        box : Void*) {

        ref = ::Box(WeakRef(typeof(self))).unbox(box).value || raise GICrystal::ObjectCollectedError.new

        # Convert from C
        {% i = 0 %}
        {% for arg in handler.args %}
        {% resolved_type = arg.resolve %}
        {% if resolved_type == String %}
          arg_{{ i }} = String.new(c_arg_{{ i }})
        {% elsif resolved_type == Path %}
          arg_{{ i }} = Path.new(String.new(c_arg_{{ i }})
        {% elsif resolved_type == Bool %}
          arg_{{ i }} = GICrystal.to_bool(c_arg_{{ i }})
        {% else %}
          arg_{{ i }} = c_arg_{{ i }}
        {% end %}
        {% i += 1 %}
        {% end %}

        ref.{{ handler.name }}( {{ (0...handler.args.size).map { |i| "arg_#{i}".id }.splat }} )
        nil
      }
      sig_handler_id = LibGObject.g_signal_connect_data(%sig.source, %sig.name, %c_slot.pointer,
        GICrystal::ClosureDataManager.register(%box),
        ->GICrystal::ClosureDataManager.deregister, 0_u32)

      GObject::SignalConnection.new(%sig.source, sig_handler_id)
    end
  end
end
