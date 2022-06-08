class GObject::Object
  # :nodoc:
  annotation GeneratedWrapper
    # This annotation is used to identify user types that inherit from GObject from binding types that does the same.
  end

  macro inherited
    {% unless @type.annotation(GObject::GeneratedWrapper) %}
      macro method_added(method)
        {% verbatim do %}
          {% if method.name.starts_with?("vfunc_") && method.name.size > 6 %}
            {% function_name = method.name[6..] %}
            def self._class_init(klass : Pointer(LibGObject::TypeClass), user_data : Pointer(Void)) : Nil
              self._class_init_vfunc_{{function_name}}(klass, user_data)
              previous_def
            end
          {% end %}
        {% end %}
      end
    {% end %}
  end
end
