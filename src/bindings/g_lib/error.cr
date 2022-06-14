module GLib
  class Error < RuntimeError
    @pointer : Pointer(LibGLib::Error)

    # :nodoc:
    def initialize(pointer : Pointer(LibGLib::Error), transfer : GICrystal::Transfer)
      message_ptr = pointer.value.message
      super(String.new(message_ptr)) unless message_ptr.null?
      @pointer = if transfer.none?
                   LibGLib.g_error_copy(pointer)
                 else
                   pointer
                 end
    end

    # :nodoc:
    def self.allocate
      ptr = GC.malloc_atomic(instance_sizeof(self)).as(self)
      set_crystal_type_id(ptr)
      ptr
    end

    def finalize
      {% if flag?(:debugmemory) %}
        LibC.printf("~GLib::Error at %p\n", @pointer)
      {% end %}
      LibGLib.g_error_free(@pointer)
    end

    # Return numerical error code
    def code : Int32
      @pointer.value.code
    end

    # Return the error domain, only useful if the error is unknown to the binding, otherwise is faster to just
    # check for the error class.
    def domain : String
      String.new(LibGLib.g_quark_to_string(error.value.domain))
    end

    def to_unsafe
      @pointer
    end
  end
end
