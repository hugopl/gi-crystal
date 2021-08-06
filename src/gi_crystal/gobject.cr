lib LibGObject
  # Signals
  fun g_signal_connect_data(instance : Void*,
                            detailed_signal : UInt8*,
                            c_handler : Void*,
                            data : Void*,
                            destroy_data : Void* -> Nil,
                            flags : UInt32) : UInt64
end

module GObject
  # Code kindly stolen from crystal-gobject shard
  class ClosureDataManager
    def self.instance
      @@instance ||= new
    end

    def self.deregister(data : Pointer(Void)) : Nil
      instance.deregister(data)
    end

    def self.register(data : Pointer(Void)) : Pointer(Void)
      instance.register(data)
    end

    private def initialize
      @closure_data = Hash(Pointer(Void), Int32).new { |h, k| h[k] = 0 }
    end

    def register(data : Pointer(Void)) : Pointer(Void)
      @closure_data[data] += 1 if data
      data
    end

    def deregister(data : Pointer(Void)) : Nil
      @closure_data[data] -= 1
      if @closure_data[data] <= 0
        @closure_data.delete(data)
      end
    end
  end

  struct Signal(Obj, Ret, *Params)
    @source : Pointer(Void)
    @signal : String
    @full_slot : Pointer(Void)
    @half_slot : Pointer(Void)

    NORMAL = 0
    AFTER  = 1

    def initialize(@source, @signal, @full_slot, @half_slot)
    end

    def [](detail : String) : self
      self.class.new(@source, "#{@signal}::#{detail}", @full_slot, @half_slot)
    end

    def connect(&block : Proc(*Params, Ret))
      connect(block)
    end

    def connect_after(&block : Proc(*Params, Ret))
      connect(block)
    end

    def connect(block : Proc(Obj, *Params, Ret))
      box = ::Box.box(block)
      LibGObject.g_signal_connect_data(@source, @signal, @full_slot,
        ClosureDataManager.register(box), ->ClosureDataManager.deregister, NORMAL)
    end

    def connect(block : Proc(*Params, Ret))
      box = ::Box.box(block)
      LibGObject.g_signal_connect_data(@source, @signal, @half_slot,
        ClosureDataManager.register(box), ->ClosureDataManager.deregister, NORMAL)
    end

    def connect_after(block : Proc(Obj, *Params, Ret))
      box = ::Box.box(block)
      LibGObject.g_signal_connect_data(@source, @signal, @full_slot,
        ClosureDataManager.register(box), ->ClosureDataManager.deregister, AFTER)
    end

    def connect_after(block : Proc(*Params, Ret))
      box = ::Box.box(block)
      LibGObject.g_signal_connect_data(@source, @signal, @half_slot,
        ClosureDataManager.register(box), ->ClosureDataManager.deregister, AFTER)
    end
  end
end
