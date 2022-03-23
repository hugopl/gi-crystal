require "spec"

require "../src/gi-crystal"
require "../src/auto/test-1.0/test"

# Used on basic signal tests or on something that would need a kind of global var to
# be sure something was called in another context.
class GlobalVar
  class_property value = ""

  def self.reset
    @@value = ""
  end
end

Spec.after_each do
  GlobalVar.reset
  # Run GC between tests to try to catch some GC related bugs
  # Why 5 times? No idea... I was just unsure of doing just a single call.
  5.times { GC.collect }
end
