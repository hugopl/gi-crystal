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

    def [](n : Int32) : T
      self[n]?.not_nil!
    end

    def []?(n : Int32) : T?
      value = LibGLib.g_list_nth(self, n)
      return if value.null?

      to_crystal(value)
    end

    private def to_crystal(item : Pointer(LibGLib::List))
      data = item.value.data

      {% if T == String %}
        T.new(data.as(Pointer(LibC::Char)))
      {% elsif T.module? %}
        {{ T.name.stringify.gsub(/(.*)(::)([^:]*)\z/, "\\1::Abstract\\3").id }}.new(data, :none)
      {% else %}
        T.new(data, :none)
      {% end %}
    end

    def finalize
      if @transfer.full?
        {% if T <= GObject::Object || T.module? %}
          LibGLib.g_list_free_full(self, ->LibGObject.g_object_unref)
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
