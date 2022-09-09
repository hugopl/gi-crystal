module GICrystal
  # :nodoc:
  # This class is used to toggle GObject subclasses' references between a strong and weak state.
  module ToggleRefManager
    def self.register(data : Void*) : Void*
      node = GC.malloc_uncollectable(sizeof(Void*))
      node.as(Void**).value = data

      {% if flag?(:debugmemory) %}
        puts "Registering #{data} on ToggleRefManager as #{node}"
      {% end %}

      node
    end

    def self.deregister(node : Void*) : Nil
      {% if flag?(:debugmemory) %}
        puts "Deregistering #{node} on ToggleRefManager"
      {% end %}

      GC.free(node)
    end
  end
end
