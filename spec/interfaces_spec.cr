require "./spec_helper"

describe "GObject interfaces" do
  it "can be returned by methods" do
    subject = Test::Subject.new
    myself = subject.return_myself_as_interface
    subject.string.should eq("test_subject_return_myself_as_interface")
    subject.to_unsafe.should eq(myself.to_unsafe)
  end

  it "have property accessors" do
    subject = Test::Subject.new
    iface = subject.return_myself_as_interface
    iface.float64 = 1.5
    subject.float64.should eq(1.5)
    iface.float64.should eq(1.5)
    subject.ref_count.should eq(2)
    iface.ref_count.should eq(2)
  end
end
