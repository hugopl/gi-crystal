module GLib
  class SList(T)
    include Enumerable(T)

    @list : Pointer(LibGLib::SList)
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
      LibGLib.g_slist_length(self)
    end

    def [](n : Int32) : T
      self[n]?.not_nil!
    end

    def []?(n : Int32) : T?
      value = LibGLib.g_slist_nth(self, n)
      return if value.null?

      to_crystal(value)
    end

    private def to_crystal(item : Pointer(LibGLib::SList))
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
          LibGLib.g_slist_free_full(self, ->LibGObject.g_object_unref)
        {% else %}
          LibGLib.g_slist_free_full(self, ->LibGLib.g_free)
        {% end %}
      elsif @transfer.container?
        LibGLib.g_slist_free(self)
      end
    end

    def to_unsafe
      @list
    end
  end
end
