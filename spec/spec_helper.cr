require "spec"

require "../src/gi-crystal"
require "../src/generated/gio-2.0/gio"
require "../src/generated/test-1.0/test"

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

# This flag is used by different tests, so it's here
@[Flags]
enum TestFlags
  A  = 1
  B  = 2
  C  = 4
  D  = 8
  BC = 6
end

# This enum is used by different tests, so it's here
enum TestEnum
  X
  Y
  Z
  Odd_Välue = Int32::MAX
end
