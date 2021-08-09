module GICrystal
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
end
