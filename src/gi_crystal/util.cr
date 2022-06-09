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

  INSTANCE_QDATA_KEY     = LibGLib.g_quark_from_static_string("gi-crystal::instance")
  GC_COLLECTED_QDATA_KEY = LibGLib.g_quark_from_static_string("gi-crystal::gc-collected")

  class ObjectCollectedError < RuntimeError
  end

  def gc_collected?(object) : Bool
    {% raise "Implement GICrystal.gc_collected?(object) for your fundamental type." %}
  end

  def instance_pointer(object) : Pointer(Void)
    {% raise "Implement GICrystal.instance_pointer(object) for your fundamental type." %}
  end

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

  macro define_new_method(type, qdata_get_func, qdata_set_func)
    # :nodoc:
    def self.new(pointer : Pointer(Void), transfer : GICrystal::Transfer) : self
      # Try to recover the Crystal instance if any
      instance = LibGObject.{{ qdata_get_func }}(pointer, GICrystal::INSTANCE_QDATA_KEY)
      return instance.as({{ type }}) if instance

      # This object never meet Crystal land, so we allocate memory and initialize it.
      instance = {{ type }}.allocate
      LibGObject.{{ qdata_set_func }}(pointer, GICrystal::INSTANCE_QDATA_KEY, Pointer(Void).new(instance.object_id))
      instance.initialize(pointer, transfer)
      GC.add_finalizer(instance)
      instance
    end
  end

  extend self
end
