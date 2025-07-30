module GICrystal
  # :nodoc:
  # ClosureDataManager stores a table with pointers to counters.
  #
  # When connecting signals we store Crystall callbacks in `::Box` objects, if there's no reference to these box objects the
  # Garbage Collector will collect them and the program will crash when the signal gets emitted.
  #
  # ClosureDataManager is used to hold a reference for these objects and avoid them to be collected while they can still
  # be used.
  #
  # People writing GTK programs must never need to use this function.
  class ClosureDataManager
    def self.instance
      @@instance ||= new
    end

    # De-register a pointer, if the count equals to zero, the pointer is removed.
    def self.deregister(data : Pointer(Void)) : Nil
      instance.deregister(data)
    end

    # Register a pointer, if it's already registered the counter will be increased.
    def self.register(data : Pointer(Void)) : Pointer(Void)
      instance.register(data)
    end

    # Returns number of references hold.
    def self.count : Int32
      instance.count
    end

    # Print all pointers registered on ClosureDataManager
    def self.info(io : IO = STDOUT)
      instance.info(io)
    end

    # Deregister all references hold, no matter their counts.
    def self.deregister_all
      instance.deregister_all
    end

    {% if flag?(:preview_mt) %}
      @mutex = Mutex.new
    {% end %}

    private def initialize
      @closure_data = Hash(Pointer(Void), Int32).new { |h, k| h[k] = 0 }
    end

    private def synchronize(&)
      {% if flag?(:preview_mt) %}
        @mutex.synchronize do
          yield
        end
      {% else %}
        yield
      {% end %}
    end

    def deregister_all
      synchronize do
        @closure_data.clear
      end
    end

    def count : Int32
      synchronize do
        @closure_data.each_value.sum
      end
    end

    def info(io : IO)
      synchronize do
        @closure_data.each do |ptr, count|
          io.puts "0x#{ptr.address.to_s(16)} -> #{count}"
        end
        io.puts "total closures on hold: #{@closure_data.size}"
      end
    end

    def register(data : Pointer(Void)) : Pointer(Void)
      synchronize do
        {% if flag?(:debugmemory) %}
          puts "Registering #{data.address.to_s(16)} on ClosureDataManager, count: #{@closure_data[data]? || 0}."
        {% end %}
        @closure_data[data] += 1 if data
        data
      end
    end

    def deregister(data : Pointer(Void)) : Nil
      synchronize do
        {% if flag?(:debugmemory) %}
          puts "Deregistering #{data.address.to_s(16)} from ClosureDataManager, count: #{@closure_data[data]}."
        {% end %}

        @closure_data[data] -= 1
        if @closure_data[data] <= 0
          @closure_data.delete(data)
        end
      end
    end
  end
end
