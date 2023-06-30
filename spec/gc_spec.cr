require "./spec_helper"

private class GCResistantObj < GObject::Object
  property moto : String

  def initialize(@moto)
    super()
  end
end

@[NoInline]
private def create_gc_resistant_object : Test::Subject
  subject = Test::Subject.new
  gc_resistance = GCResistantObj.new("viva la resistance!")
  # subject.gobj will hold a reference to `gc_resistance`, so if GC collect it the contents of `GCResistantObj#moto`
  # will be collected as well.
  subject.gobj = gc_resistance
  subject
end

describe "GC resistant GObject subclasses" do
  it "don't get collected by GC" do
    subject = create_gc_resistant_object
    GC.collect

    gc_resistance = subject.gobj.as(GCResistantObj)
    gc_resistance.moto.should eq("viva la resistance!")
    gc_resistance.ref_count.should eq(2)
  end
end
