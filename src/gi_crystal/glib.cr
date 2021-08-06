# This file is included automatically when generating glib binding
lib LibGLib
  # Memory related functions
  fun g_malloc0(size : LibC::SizeT) : Void*
  fun g_free(mem : Void*)
  fun g_boxed_free(type : UInt64, mem : Void*)

  # GList
  fun g_list_length(list : List*) : UInt32
  fun g_list_free(list : List*)
  fun g_list_free_full(list : List*, free_func : Proc(Void*, Nil))
  fun g_list_first(list : List*) : List*
  fun g_list_last(list : List*) : List*
end

module GLib
  class List(T)
    include Enumerable(T)

    @list : Pointer(LibGLib::List)
    @transfer : GICrystal::Transfer

    def initialize(@list, @transfer)
    end

    def each(&block : T -> _)
      list = @list
      while list
        yield to_crystal(list)

        list = list.value._next
      end
    end

    def size
      LibGLib.g_list_length(self)
    end

    def first : T
      first?.not_nil!
    end

    def first? : T?
      item = LibGLib.g_list_first(self)
      return if item.null?

      to_crystal(item)
    end

    def last : T
      last?.not_nil!
    end

    def last? : T?
      item = LibGLib.g_list_last(self)
      return if item.null?

      to_crystal(item)
    end

    private def to_crystal(item : Pointer(LibGLib::List))
      data = item.value.data

      {% if T == String %}
        T.new(data.as(Pointer(LibC::Char)))
      {% else %}
        T.new(data)
      {% end %}
    end

    def finalize
      if @transfer.full?
        {% if T > GObject::Object %}
          LibGLib.g_list_free_full(self, ->LibGLib.g_object_unref)
        {% else %}
          LibGLib.g_list_free_full(self, ->LibGLib.g_free)
        {% end %}
      elsif @transfer.container?
        LibGLib.g_list_free(self)
      end
    end

    def to_unsafe
      @list
    end
  end
end
