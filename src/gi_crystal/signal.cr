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
  struct Signal(Obj, Ret, *Params)
    @source : Pointer(Void)
    @signal : String
    @full_slot : Pointer(Void)
    @half_slot : Pointer(Void)

    private NORMAL = 0
    private AFTER  = 1

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
        GICrystal::ClosureDataManager.register(box), ->GICrystal::ClosureDataManager.deregister, NORMAL)
    end

    def connect(block : Proc(*Params, Ret))
      box = ::Box.box(block)
      LibGObject.g_signal_connect_data(@source, @signal, @half_slot,
        GICrystal::ClosureDataManager.register(box), ->GICrystal::ClosureDataManager.deregister, NORMAL)
    end

    def connect_after(block : Proc(Obj, *Params, Ret))
      box = ::Box.box(block)
      LibGObject.g_signal_connect_data(@source, @signal, @full_slot,
        GICrystal::ClosureDataManager.register(box), ->GICrystal::ClosureDataManager.deregister, AFTER)
    end

    def connect_after(block : Proc(*Params, Ret))
      box = ::Box.box(block)
      LibGObject.g_signal_connect_data(@source, @signal, @half_slot,
        GICrystal::ClosureDataManager.register(box), ->GICrystal::ClosureDataManager.deregister, AFTER)
    end
  end
end
