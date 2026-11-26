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

private class ConstructedVFuncImpl < GObject::Object
  class_property? constructed_called = false

  @[GObject::Virtual]
  def constructed
    @@constructed_called = true
  end
end

private class DisposeVFuncImpl < GObject::Object
  class_property dispose_calls = 0

  @[GObject::Virtual]
  def dispose
    @@dispose_calls += 1
  end
end

@[NoInline]
private def create_and_drop_dispose_vfunc_impl : Nil
  DisposeVFuncImpl.new
  nil
end

describe "GObject vfuncs called during object life cycle" do
  # Bug: `GObject::Object#initialize` (src/bindings/g_object/object.cr) calls `g_object_newv` and only then stores the
  # Crystal instance in the `INSTANCE_QDATA_KEY` qdata. `g_object_newv` calls the `constructed` vfunc, the vfunc
  # trampoline (ecr/v_func.ecr) can't find the Crystal instance in the qdata yet and raises
  # `GICrystal::ObjectCollectedError` from inside a C frame. Any vfunc called during construction (`constructed`,
  # `set_property` for construct properties, ...) has the same problem.
  #
  # Fix: make the Crystal instance available before the vfuncs can be called, e.g. set the qdata in
  # `_instance_init` (called by GObject before `constructed`), or keep it in a thread local "instance being
  # constructed" slot that the trampolines fall back to.
  pending "calls constructed vfunc implemented in Crystal" do
    ConstructedVFuncImpl.constructed_called = false
    ConstructedVFuncImpl.new
    ConstructedVFuncImpl.constructed_called?.should eq(true)
  end

  # When the Crystal object is collected the GObject is disposed and finalized from inside the Crystal finalizer,
  # vfuncs implemented in Crystal must still be able to find the Crystal instance at that point.
  it "calls dispose vfunc implemented in Crystal when the object is collected" do
    DisposeVFuncImpl.dispose_calls = 0
    create_and_drop_dispose_vfunc_impl
    10.times do
      GC.collect
      100.times { Array(Int32).new(16) }
    end
    DisposeVFuncImpl.dispose_calls.should eq(1)
  end
end
