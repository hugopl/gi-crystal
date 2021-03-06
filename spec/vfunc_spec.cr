require "./spec_helper"

private class IfaceVFuncImpl < GObject::Object
  include Test::IfaceVFuncs

  getter int32 = 0
  getter float32 = 0.0_f32
  getter float64 = 0.0
  getter string : String?
  getter obj : GObject::Object?

  @[GObject::Virtual]
  def vfunc_basic(@int32, @float32, @float64, @string, @obj)
  end

  @[GObject::Virtual]
  def vfunc_return_string
    "string returned from vfunc!"
  end

  @[GObject::Virtual]
  def vfunc_return_enum
    Test::RegularEnum::Value2
  end
end

private class UnsafeIfaceVFuncImpl < GObject::Object
  include Test::IfaceVFuncs

  getter int32 = 0
  getter float32 = 0.0_f32
  getter float64 = 0.0
  getter string : String?
  getter obj : GObject::Object?

  @[GObject::Virtual(unsafe: true, name: "vfunc_basic")]
  def do_it(@int32, @float32, @float64, c_string : Pointer(UInt8), obj : Pointer(Void))
    @string = String.new(c_string) if c_string
    @obj = GObject::Object.new(obj, :full)
  end
end

describe "GObject vfuncs" do
  it "can receive number parameters" do
    obj = IfaceVFuncImpl.new
    obj.call_vfunc("vfunc_basic")
    obj.int32.should eq(1)
    obj.float32.should eq(2.2_f32)
    obj.float64.should eq(3.3)
    obj.string.should eq("string")
    subject = Test::Subject.cast(obj.obj)
    subject.ref_count.should eq(1)
    subject.string.should eq("hey")
  end

  it "can have unsafe implementations" do
    obj = UnsafeIfaceVFuncImpl.new
    obj.call_vfunc("vfunc_basic")
    obj.int32.should eq(1)
    obj.float32.should eq(2.2_f32)
    obj.float64.should eq(3.3)
    obj.string.should eq("string")
    subject = Test::Subject.cast(obj.obj)
    subject.ref_count.should eq(1)
    subject.string.should eq("hey")
  end

  it "can have return a string" do
    obj = IfaceVFuncImpl.new
    obj.call_vfunc("vfunc_return_string").should eq("string returned from vfunc!")
  end

  it "can have return an enum" do
    obj = IfaceVFuncImpl.new
    obj.call_vfunc("vfunc_return_enum").should eq("TEST_VALUE2")
  end

  pending "can be from objects, not interfaces"
end
