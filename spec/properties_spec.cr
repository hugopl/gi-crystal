require "./spec_helper"

describe "GObject properties" do
  context "when set in constructors" do
    it "works for more than one item" do
      subject = Test::Subject.new(string: "hey", int32: 42, enum: :value2, boolean: false)
      subject.string.should eq("hey")
      subject.int32.should eq(42)
      subject.boolean?.should eq(false)
      subject.enum.should eq(Test::RegularEnum::Value2)
    end

    it "can set interface properties" do
      subject = Test::Subject.new(float64: 0.5)
      subject.float64.should eq(0.5)
    end

    it "works for null terminated strings" do
      subject = Test::Subject.new(str_list: %w(hey ho))
      subject.str_list.should eq(%w(hey ho))
    end
  end

  it "can be float64/can be set in interfaces" do
    subject = Test::Subject.new
    subject.float64.should eq(0.0)
    subject.float64 = 1.25
    subject.float64.should eq(1.25)
  end

  it "can be strings" do
    subject = Test::Subject.new
    subject.string = "hey ho"
    subject.string.should eq("hey ho")
    subject.string?.should eq("hey ho")
  end

  it "can be nullable strings" do
    subject = Test::Subject.new
    subject.string = nil
    subject.string?.should eq(nil)
  end

  it "can be boolean" do
    subject = Test::Subject.new
    subject.boolean?.should eq(true)
    subject.boolean = false
    subject.boolean?.should eq(false)
    subject.boolean = true
    subject.boolean?.should eq(true)
  end

  it "can be integers" do
    subject = Test::Subject.new
    subject.int32.should eq(0)
    subject.int32 = 42
    subject.int32.should eq(42)
  end

  it "can be enums" do
    subject = Test::Subject.new
    subject.enum.should eq(Test::RegularEnum::Value1)
    subject.enum = :value3
    subject.enum.should eq(Test::RegularEnum::Value3)
  end

  it "can be gobject interfaces" do
    subject = Test::Subject.new
    subject.iface.should eq(nil)

    value = Test::Subject.new(boolean: true)
    subject.iface = value
    value.ref_count.should eq(2)
    subject.iface.not_nil!.to_unsafe.should eq(value.to_unsafe)
  end

  it "can be GObjects" do
    subject = Test::Subject.new
    subject.gobj.should eq(nil)

    value = Test::Subject.new
    subject.gobj = value
    value.ref_count.should eq(2)
    subject.gobj.object_id.should eq(value.object_id)
    value.ref_count.should eq(2)

    subject.gobj = value.may_return_null(true)
    value.ref_count.should eq(1)
    subject.gobj.should eq(nil)
  end

  it "can be null terminated string lists" do
    subject = Test::Subject.new
    subject.str_list.empty?.should eq(true)

    subject.str_list = {"hey", "ho"}
    subject.str_list.should eq(%w(hey ho))

    subject.str_list = %w(let go)
    subject.str_list.should eq(%w(let go))
  end

  context "when of boolean type" do
    it "transform `is_prop` to `is_prop?`" do
      subject = Test::Subject.new(boolean: true)
      subject.is_bool?.should eq(true)
      subject.boolean?.should eq(true)
    end
  end
end
