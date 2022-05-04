require "./spec_helper"

def func_with_iface_param(iface : Test::Iface)
  iface.return_myself_as_interface
end

describe "GObject interfaces" do
  it "can be returned by methods" do
    subject = Test::Subject.new(boolean: true)
    myself = subject.return_myself_as_interface
    subject.string.should eq("test_subject_return_myself_as_interface")
    subject.to_unsafe.should eq(myself.to_unsafe)
  end

  it "have property accessors" do
    subject = Test::Subject.new(boolean: true)
    iface = subject.return_myself_as_interface
    iface.float64 = 1.5
    subject.float64.should eq(1.5)
    iface.float64.should eq(1.5)
    # All Crystal instances share the same GObject ref count, since all instances are in the same memory address and
    # will call finalize only once.
    subject.ref_count.should eq(1)
    iface.ref_count.should eq(1)
  end

  it "have class methods" do
    Test::Iface.class_method
  end

  it "have abstract to_unsafe method" do
    typeof(->func_with_iface_param(Test::Iface))

    # Test::AbstractIface.new
  end
end
