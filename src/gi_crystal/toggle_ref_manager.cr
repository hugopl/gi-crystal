module GICrystal
  # :nodoc:
  # This class is used to toggle GObject subclasses' references between a strong and weak state.
  # This is achieved using a doubly linked list.
  # Because this implementation is meant to be fast, Crystal::PointerLinkedList could not be used
  # as it does not return pointers to the nodes, which would be needed.
  module ToggleRefManager
    @@linked_list = DoublyLinkedList(Void*).new

    def self.register(data : Void*) : Void*
      @@linked_list.add(data)
    end

    def self.deregister(node : Void*) : Nil
      @@linked_list.remove(node)
    end
  end

  # :nodoc:
  class DoublyLinkedList(T)
    private struct Node(T)
      property prev : Node(T)*
      property next : Node(T)*
      property value : T

      def initialize(@prev : Node(T)*, @next : Node(T)*, @value : T)
      end
    end

    @head : Node(T)* = Pointer(Node(T)).null

    def remove(node : Pointer(Void)) : Nil
      {% if flag?(:debugmemory) %}
        puts "Deregistering #{node} from ToggleRefManager"
      {% end %}

      node_value = node.as(Node(T)*).value
      node_value.prev.value = node_value.prev.value.tap { |prev_node| prev_node.next = node_value.next } unless node_value.prev.null?
      node_value.next.value = node_value.next.value.tap { |next_node| next_node.prev = node_value.prev } unless node_value.next.null?
      @head = node_value.prev if node.as(Node(T)*) == @head
      GC.free(node)
    end

    def add(data : T) : Pointer(Void)
      node_ptr = Pointer(Node(T)).malloc(1)

      {% if flag?(:debugmemory) %}
        puts "Registering #{data} on ToggleRefManager as #{node_ptr.as(Void*)}"
      {% end %}

      node_ptr.value = Node(T).new(@head, Pointer(Node(T)).null, data)
      @head.value = @head.value.tap { |head| head.next = node_ptr } unless @head.null?
      @head = node_ptr
      node_ptr.as(Void*)
    end
  end
end
