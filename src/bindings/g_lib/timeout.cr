module GLib
  enum Priority
    Default     = PRIORITY_DEFAULT
    DefaultIdle = PRIORITY_DEFAULT_IDLE
    High        = PRIORITY_HIGH
    HighIdle    = PRIORITY_HIGH_IDLE
    Low         = PRIORITY_LOW
  end

  def self.idle_add(priority : Priority = Priority::Default, &block : -> Bool)
    box = Box.box(block)
    slot = ->(box_ptr : Pointer(Void)) { Box(Proc(Bool)).unbox(box_ptr).call.to_unsafe }.pointer

    LibGLib.g_idle_add_full(priority, slot,
      GICrystal::ClosureDataManager.register(box), ->GICrystal::ClosureDataManager.deregister(Pointer(Void)).pointer)
  end

  def self.timeout_seconds(interval : UInt32, priority : Priority = Priority::Default, &block : -> Bool)
    raise ArgumentError.new("Timeout must be at least 1 second") unless interval > 0

    box = Box.box(block)
    slot = ->(box_ptr : Pointer(Void)) { Box(Proc(Bool)).unbox(box_ptr).call.to_unsafe }.pointer

    LibGLib.g_timeout_add_seconds_full(priority, interval, slot,
      GICrystal::ClosureDataManager.register(box), ->GICrystal::ClosureDataManager.deregister(Pointer(Void)).pointer)
  end

  def self.timeout_milliseconds(interval : UInt32, priority : Priority = Priority::Default, &block : -> Bool)
    raise ArgumentError.new("Timeout must be at least 1 millisecond") unless interval > 0

    box = Box.box(block)
    slot = ->(box_ptr : Pointer(Void)) { Box(Proc(Bool)).unbox(box_ptr).call.to_unsafe }.pointer

    LibGLib.g_timeout_add_full(priority, interval, slot,
      GICrystal::ClosureDataManager.register(box), ->GICrystal::ClosureDataManager.deregister(Pointer(Void)).pointer)
  end

  def self.timeout(interval : Time::Span, priority : Priority = Priority::Default, &block : -> Bool)
    if interval.milliseconds.zero?
      self.timeout_seconds(interval.total_seconds.to_u32, priority, &block)
    else
      self.timeout_milliseconds(interval.total_milliseconds.to_u32, priority, &block)
    end
  end
end
