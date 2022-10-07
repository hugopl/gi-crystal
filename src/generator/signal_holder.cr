require "./signal_gen"

module Generator
  module SignalHolder
    private macro render_signals
      object.signals.each do |signal|
        SignalGen.new(object, signal).generate(io)
      end
    end
  end
end
