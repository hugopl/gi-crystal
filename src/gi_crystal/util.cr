# This module have types, functions and macros used by the generated bindings, if you are just using the bindings you
# should never deal with any of this.
module GICrystal
  # How the memory ownership is transfered (or not) from C to Crystal and vice-versa.
  enum Transfer
    # Transfer nothing from the callee (function or the type instance the property belongs to) to the caller.
    None
    # Transfer the container (list, array, hash table) from the callee to the caller.
    Container
    # Transfer everything, e.g. the container and its contents from the callee to the caller.
    Full
  end

  # See `declare_new_method`.
  INSTANCE_QDATA_KEY = LibGLib.g_quark_from_static_string("gi-crystal::instance")
  # See `declare_new_method`.
  GC_COLLECTED_QDATA_KEY = LibGLib.g_quark_from_static_string("gi-crystal::gc-collected")

  # Raised when trying to cast an object that was already collected by GC.
  class ObjectCollectedError < RuntimeError
  end

  # :nodoc:
  def gc_collected?(object) : Bool
    {% raise "Implement GICrystal.gc_collected?(object) for your fundamental type." %}
  end

  # :nodoc:
  def instance_pointer(object) : Pointer(Void)
    {% raise "Implement GICrystal.instance_pointer(object) for your fundamental type." %}
  end

  # :nodoc:
  def finalize_instance(object)
    {% raise "Implement GICrystal.finalize_instance(object) for your fundamental type." %}
  end

  # :nodoc:
  @[AlwaysInline]
  def to_unsafe(value : String?)
    value ? value.to_unsafe : Pointer(UInt8).null
  end

  # :nodoc:
  @[AlwaysInline]
  def to_bool(value : Int32) : Bool
    value != 0
  end

  # :nodoc:
  def transfer_null_ended_array(ptr : Pointer(Pointer(UInt8)), transfer : Transfer) : Array(String)
    res = Array(String).new
    return res if ptr.null?

    item_ptr = ptr
    while !item_ptr.value.null?
      res << String.new(item_ptr.value)
      LibGLib.g_free(item_ptr.value) if transfer.full?
      item_ptr += 1
    end
    LibGLib.g_free(ptr) unless transfer.none?
    res
  end

  # :nodoc:
  def transfer_array(ptr : Pointer(Pointer(UInt8)), length : Int, transfer : Transfer) : Array(String)
    res = Array(String).new(length)
    return res if ptr.null?

    length.times do |i|
      item_ptr = (ptr + i).value
      res << String.new(item_ptr)
      LibGLib.g_free(item_ptr) if transfer.full?
    end
    LibGLib.g_free(ptr) unless transfer.none?
    res
  end

  # :nodoc:
  def transfer_array(ptr : Pointer(UInt8), length : Int, transfer : Transfer) : Slice(UInt8)
    slice = Slice(UInt8).new(ptr, length, read_only: true)
    if transfer.full?
      slice = slice.clone
      LibGLib.g_free(ptr)
    end
    slice
  end

  # :nodoc:
  def transfer_array(ptr : Pointer(T), length : Int, transfer : Transfer) : Array(T) forall T
    Array(T).build(length) do |buffer|
      ptr.copy_to(buffer, length)
      length
    end
  ensure
    LibGLib.g_free(ptr) if transfer.full?
  end

  # :nodoc:
  def transfer_full(str : Pointer(UInt8)) : String
    String.new(str).tap do
      LibGLib.g_free(str)
    end
  end

  # This declare the `new` method, *qdata_get_func* and *qdata_set_func* are functions used
  # to set/get qdata on objects, e.g. `g_object_get_qdata`/`g_object_set_qdata` for GObjects.
  #
  # GICrystal stores two qdatas in objects on following keys:
  #
  # - INSTANCE_QDATA_KEY: Store the pointer of Crystal wrapper for this C object.
  # - GC_COLLECTED_QDATA_KEY: Store 1 if the GC was called for the Crystal wrapper, 0 otherwise.
  #
  # `INSTANCE_QDATA_KEY` is used when a object comes from a C function and instead of allocate a new wrapper for it
  # we just restore the old one.
  # `GC_COLLECTED_QDATA_KEY` is used to avoid to restore a wrapper that was already collected by GC.
  #
  # This is mainly used for `GObject::Object`, since `GObject::ParamSpec` doesn't support casts on GICrystal.
  macro declare_new_method(qdata_get_func, qdata_set_func)
    # :nodoc:
    def self.new(pointer : Pointer(Void), transfer : GICrystal::Transfer) : self
      # Try to recover the Crystal instance if any
      instance = LibGObject.{{ qdata_get_func }}(pointer, GICrystal::INSTANCE_QDATA_KEY)
      return instance.as(self) if instance

      # This object never meet Crystal land, so we allocate memory and initialize it.
      instance = self.allocate
      LibGObject.{{ qdata_set_func }}(pointer, GICrystal::INSTANCE_QDATA_KEY, Pointer(Void).new(instance.object_id))
      instance.initialize(pointer, transfer)
      GC.add_finalizer(instance)
      instance
    end
  end

  extend self
end
