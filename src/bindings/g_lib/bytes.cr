module GLib
  class Bytes
    def initialize(data : Pointer, size : Int32)
      @pointer = LibGLib.g_bytes_new(data, size)
    end
  end
end
