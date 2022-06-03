module GLib
  class Bytes
    def initialize(data : Pointer, size : Int32)
      @pointer = LibGLib.g_bytes_new(data, size)
    end

    def data : Slice(UInt8)
      data_size = 0_u64
      data = LibGLib.g_bytes_get_data(@pointer, pointerof(data_size))
      Slice.new(data.as(Pointer(UInt8)), data_size)
    end
  end
end
