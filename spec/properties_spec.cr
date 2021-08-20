describe "GObject properties" do
  it "can be strings" do
    subject = Test::Subject.new
    subject.string = "hey ho"
    subject.string.should eq("hey ho")
  end

  it "can be integers" do
    subject = Test::Subject.new
    subject.int32.should eq(0)
    subject.int32 = 42
    subject.int32.should eq(42)
  end

  it "can be gobject interfaces" do
    subject = Test::Subject.new
    subject.iface.should eq(nil)

    value = Test::Subject.new
    subject.iface = value
    value.ref_count.should eq(2)
    subject.iface.not_nil!.to_unsafe.should eq(value.to_unsafe)
  end
end
