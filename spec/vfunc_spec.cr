require "./spec_helper"

private class IfaceVFuncImpl < GObject::Object
  include Test::IfaceVFuncs

  getter int32 = 0
  getter float32 = 0.0_f32
  getter float64 = 0.0
  getter string : String?
  getter obj : GObject::Object?
  property bool_return_value = false
  property nullable_string_return_value : String?
  property nullable_obj_return_value : Test::Subject?

  @[GObject::Virtual]
  def vfunc_basic(@int32, @float32, @float64, @string, @obj)
  end

  @[GObject::Virtual]
  def vfunc_return_string
    "string returned from vfunc!"
  end

  @[GObject::Virtual]
  def vfunc_return_bool : Bool
    @bool_return_value
  end

  @[GObject::Virtual]
  def vfunc_return_enum
    Test::RegularEnum::Value2
  end

  @[GObject::Virtual]
  def vfunc_return_nullable_string : String?
    @nullable_string_return_value
  end

  @[GObject::Virtual]
  def vfunc_return_nullable_obj : Test::Subject?
    @nullable_obj_return_value
  end

  @[GObject::Virtual]
  def vfunc_return_transfer_full_obj : Test::Subject?
    @nullable_obj_return_value
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

  @[GObject::Virtual(unsafe: true, name: "vfunc_bubble_up")]
  def vfunc_bubble_up : UInt32
    ret = previous_vfunc!
    raise "Funny number not found" unless ret == 0xDEADBEEF
    ret
  end

  @[GObject::Virtual(unsafe: true, name: "vfunc_bubble_up_with_args")]
  def vfunc_bubble_up_with_args(a : UInt32) : UInt32
    ret = previous_vfunc!(a + 1)
    raise "Wrong number returned" unless ret == 7
    ret
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
    subject.ref_count.should eq(2) # now 2 wrappers for the same C obj
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
    subject.ref_count.should eq(2) # now 2 wrappers for the same C obj
    subject.string.should eq("hey")
  end

  it "can return a string" do
    obj = IfaceVFuncImpl.new
    obj.call_vfunc("vfunc_return_string").should eq("string returned from vfunc!")
  end

  it "can return a boolean" do
    obj = IfaceVFuncImpl.new
    obj.bool_return_value = true
    obj.call_vfunc("vfunc_return_bool").should eq("true")
    obj.bool_return_value = false
    obj.call_vfunc("vfunc_return_bool").should eq("false")
  end

  it "can return an enum" do
    obj = IfaceVFuncImpl.new
    obj.call_vfunc("vfunc_return_enum").should eq("TEST_VALUE2")
  end

  it "can return nil on a String? return type restriction" do
    obj = IfaceVFuncImpl.new
    obj.call_vfunc("vfunc_return_nullable_string").should eq("NULL")
  end

  it "can return an String on a String? return type restriction" do
    obj = IfaceVFuncImpl.new
    obj.nullable_string_return_value = "hey"
    obj.call_vfunc("vfunc_return_nullable_string").should eq("hey")
  end

  it "can return nil on a Object? return type restriction" do
    obj = IfaceVFuncImpl.new
    obj.call_vfunc("vfunc_return_nullable_string").should eq("NULL")
  end

  it "can return an object on a Object? return type restriction" do
    obj = IfaceVFuncImpl.new
    obj.nullable_obj_return_value = Test::Subject.new
    obj.call_vfunc("vfunc_return_nullable_obj").should eq("Obj")
  end

  it "can return 'transfer full' objects" do
    obj = IfaceVFuncImpl.new
    obj.nullable_obj_return_value = Test::Subject.new
    # this call returns obj ref count.
    obj.call_vfunc("vfunc_return_transfer_full_obj").should eq("2")
  end

  it "can return 'transfer full' nullable objects" do
    obj = IfaceVFuncImpl.new
    obj.nullable_obj_return_value = nil
    obj.call_vfunc("vfunc_return_transfer_full_obj").should eq("NULL")
  end

  it "can chain vfuncs up" do
    obj = UnsafeIfaceVFuncImpl.new
    ret = obj.call_vfunc("vfunc_bubble_up")
    ret.should eq("success")

    ret = obj.call_vfunc("vfunc_bubble_up_with_args")
    ret.should eq("success")
  end

  pending "can be from objects, not interfaces"
end
