require "./spec_helper"

private class GCResistantObj < Test::Subject
  property moto : String

  def initialize(ctor : Symbol, @moto)
    if ctor == :use_default_ctor
      super()
    elsif ctor == :use_properties_ctor
      super(string: "string")
    else
      raise ArgumentError.new
    end
  end
end

@[NoInline]
private def create_gc_resistant_object(ctor : Symbol) : Test::Subject
  subject = Test::Subject.new
  gc_resistance = GCResistantObj.new(ctor, "viva la resistance!")
  # subject.gobj will hold a reference to `gc_resistance`, so if GC collect it the contents of `GCResistantObj#moto`
  # will be collected as well.
  subject.gobj = gc_resistance
  subject
end

# These tests may pass even with buggy code since a call to `GC.collect` is not a guarantee that
# the GC will collect everything possible.
#
# To help to reduce these false negatives (not solve), we do some blocking syscalls, so GC will find
# free time and do a mroe complete run... all this is impirical, I didn't check Boehm code, but noticed
# that if I put some `puts` in the code the test always fail if I remove the code that fixes it.
private def do_some_syscall_and_hope_gc_will_collect_more_stuff
  tempfile = File.tempfile(".bar")
  tempfile.puts("Experiments shows that GC like to un in between IO syscalls, so this is here instead of a `puts`")
  tempfile.delete
end

describe "GC resistant GObject subclasses" do
  it "don't get collected by GC when using default constructor" do
    subject = create_gc_resistant_object(:use_default_ctor)
    do_some_syscall_and_hope_gc_will_collect_more_stuff
    GC.collect

    gc_resistance = subject.gobj.as(GCResistantObj)
    gc_resistance.moto.should eq("viva la resistance!")
    gc_resistance.ref_count.should eq(2)
  end

  it "don't get collected by GC when using properties constructor" do
    subject = create_gc_resistant_object(:use_properties_ctor)
    do_some_syscall_and_hope_gc_will_collect_more_stuff
    GC.collect

    gc_resistance = subject.gobj.as(GCResistantObj)
    gc_resistance.moto.should eq("viva la resistance!")
    gc_resistance.ref_count.should eq(2)
  end
end
