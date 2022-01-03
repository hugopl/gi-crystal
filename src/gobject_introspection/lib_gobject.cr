require "./lib_glib"

@[Link("gobject-2.0", pkg_config: "gobject-2.0")]
lib LibGObject
  # This is all we need from GObject to bind GIRepository
  alias ParamFlags = UInt32
  alias SignalFlags = UInt32
end
