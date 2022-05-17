module GObject
  # This object represents a signal connection, it's used to disconnect a signal.
  #
  # If an object have any signal connection it will never be collected by the GC, so remember to disconnect all signals
  # if you want your object to be garbage collected.
  struct SignalConnection
    # The GObject signal handler ID.
    getter handler : UInt64
    # Source of this signal connection
    getter source : Object

    def initialize(@source, @handler)
    end

    # Returns true if the signal connection is active.
    def connected? : Bool
      GICrystal.to_bool(LibGObject.g_signal_handler_is_connected(@source, @handler))
    end

    # Disconnect the signal.
    def disconnect
      LibGObject.g_signal_handler_disconnect(@source, @handler)
    end
  end
end
