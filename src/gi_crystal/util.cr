# This file is included automatically on glib binding, so all bindings have it.

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

  # :nodoc:
  @[AlwaysInline]
  def to_unsafe(value : String?)
    value ? value.to_unsafe : Pointer(UInt8).null
  end

  # :nodoc:
  @[AlwaysInline]
  def to_bool(value : Int32) : Bool
    !value.zero?
  end

  # :nodoc:
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

  # :nodoc
  def transfer_array(ptr : Pointer(Pointer(UInt8)), length : Int, transfer : Transfer) : Array(String)
    res = Array(String).new(length)
    length.times do |i|
      res << String.new((ptr + i).value)
    end
    # FIXME: Lib gen if generating g_str_free as `g_str_free(char*) when it must be `g_str_free(char**)`
    if transfer.full?
      LibGLib.g_strfreev(ptr.as(Pointer(UInt8)))
    elsif transfer.container?
      LibGLib.g_free(ptr.as(Pointer(Void)))
    end
    res
  end

  def transfer_array(ptr : Pointer(UInt8), length : Int, transfer : Transfer) : Slice(UInt8)
    slice = Slice(UInt8).new(ptr, length, read_only: true)
    if transfer.full?
      slice = slice.clone
      LibGLib.g_free(ptr)
    end
    slice
  end

  # :nodoc:
  def transfer_full(str : Pointer(UInt8)) : String
    String.new(str).tap do
      LibGLib.g_free(str)
    end
  end

  extend self
end
