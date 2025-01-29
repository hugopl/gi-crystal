require "./spec_helper"

private class Obj < GObject::Object
  getter int32 = 0
  getter bool = false

  signal int32_bool(int32 : Int32, bool : Bool)

  def initialize(int32_value : Int32, bool_value : Bool)
    super()
    # Uncomment this and the test will fail, because a reference is left on ClosureManager
    #
    # int32_bool_signal.connect do |int, bool|
    #  int32_bool_slot(int, bool)
    # end

    GObject.connect(int32_bool_signal, int32_bool_slot(Int32, Bool))
    int32_bool_signal.emit(int32_value, bool_value)
  end

  def int32_bool_slot(@int32, @bool)
  end
end

@[NoInline]
private def create_obj(int32_value : Int32, bool_value : Bool)
  obj = Obj.new(int32_value, bool_value)
  {WeakRef.new(obj), obj.int32, obj.bool}
end

private class Subject < Test::Subject
  getter enum : Test::RegularEnum = Test::RegularEnum::Value1

  def initialize(enum_value : Test::RegularEnum)
    super()
    GObject.connect(enum_signal, enum_slot(Test::RegularEnum))
    enum_signal.emit(enum_value)
  end

  def enum_slot(@enum)
  end
end

@[NoInline]
private def create_subject(enum_value)
  obj = Subject.new(enum_value)
  {WeakRef.new(obj), obj.enum}
end

describe "Save signals" do
  it "does not leak memory" do
    obj_ref, int32, bool = create_obj(int32_value: 42_u32, bool_value: true)
    int32.should eq(42)
    bool.should eq(true)
    # Need to call some obj_ref method to avoid LLVM optimizations that break this test.
    obj_ref.inspect
    GC.collect
    obj_ref.value.should eq(nil)
  end

  it "works for non-user signals the same way" do
    obj_ref, enum_ = create_subject(enum_value: Test::RegularEnum::Value2)
    enum_.should eq(Test::RegularEnum::Value2)
    obj_ref.inspect
    GC.collect
    obj_ref.value.should eq(nil)
  end

  it "validate nilable parameters" do
    Gio::SimpleAction::ActivateSignal.new(GObject::Object.new, "").validate_params(::Union(GLib::Variant, ::Nil))
  end
end
