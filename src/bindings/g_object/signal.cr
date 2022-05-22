require "./signal_connection"

module GObject
  abstract struct Signal
    @source : GObject::Object
    @detail : String?

    def initialize(@source, @detail = nil)
    end

    # Return the signal with the detail added.
    def [](detail : String) : self
      raise ArgumentError.new("Signal already have a detail (#{detail}).") if @detail

      self.class.new(@source, detail)
    end

    # The signal name
    abstract def name : String
  end
end
