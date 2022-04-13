lib LibGICrystal
  # :nodoc:
  struct Object
    # Types that inherits GObject will use this structure for their instances, so it's possible to store
    # information about the Crystal object memory address and if the GC collected it
    gobject : LibGObject::Object
    gc_collected : Int32
    crystal_instance_address : UInt64
  end
end
