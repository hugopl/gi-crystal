lib LibGICrystal
  # :nodoc:
  struct ObjectPrivate
    # Private data for types that inherits GObject, so it's possible to store
    # information about the Crystal object memory address and if the GC collected it
    gc_collected : Int32
    crystal_instance_address : UInt64
  end
end
