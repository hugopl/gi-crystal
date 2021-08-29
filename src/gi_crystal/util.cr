# This file is included automatically on glib binding, so all bindings have it.

module GICrystal
  enum Transfer
    None
    Container
    Full
  end

  @[AlwaysInline]
  def to_unsafe(value : String?)
    value ? value.to_unsafe : Pointer(UInt8).null
  end

  @[AlwaysInline]
  def to_bool(value : Int32) : Bool
    !value.zero?
  end

  def transfer_null_ended_array(ptr : Pointer(Pointer(UInt8)), transfer : Transfer) : Array(String)
    res = Array(String).new
    return res if ptr.null?

    item_ptr = ptr
    while !item_ptr.value.null?
      res << String.new(item_ptr.value)
      LibGLib.g_free(item_ptr.value) if transfer.full? || transfer.container?
      item_ptr += 1
    end
    LibGLib.g_free(ptr) if transfer.full?
    res
  end

  def transfer_full(str : Pointer(UInt8)) : String
    String.new(str).tap do
      LibGLib.g_free(str)
    end
  end

  extend self
end
