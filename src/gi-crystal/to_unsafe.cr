module GICrystal
  @[AlwaysInline]
  def to_unsafe(value : Nil) : Pointer(Void)
    Pointer(Void).null
  end

  @[AlwaysInline]
  def to_unsafe(value : String | Path) : Pointer(Void)
    value.to_unsafe.as(Void*)
  end

  # Like Reference the usual `#to_unsafe` method used in Crystal language, this one returns a pointer that can
  # be passed to GTK C functions.
  #
  # To allow non-gi-crystal objects be used in Crystal we must not call `Reference#to_unsafe` but instead cast the
  # object to a void pointer, to later we can reconstruct this object when back to Crystal world from C.
  @[AlwaysInline]
  def to_unsafe(value : ObjectWrapper) : Pointer(Void)
    value.to_unsafe
  end

  @[AlwaysInline]
  def to_unsafe(value : Reference) : Pointer(Void)
    value.as(Void*)
  end

  @[AlwaysInline]
  def to_unsafe(value : Value)
    value
  end
end
