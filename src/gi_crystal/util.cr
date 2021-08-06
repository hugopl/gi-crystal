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

  def transfer_full_null_ended_list(ptr : Pointer(Pointer(UInt8))) : Array(String)
    res = Array(String).new
    while !ptr.value.null?
      res << String.new(ptr.value)
      LibGLib.g_free(ptr.value)
      ptr += 1
    end
    res
  end

  def transfer_full(str : Pointer(UInt8)) : String
    String.new(str).tap do
      LibGLib.g_free(str)
    end
  end

  extend self
end
