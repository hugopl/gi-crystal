require "./spec_helper"

private class UserObj < GObject::Object
  @[GObject::Property]
  property crystal_prop1 = ""
  getter crystal_attr : Int32 = 42

  def initialize
    super
  end
end

private class InheritedUserObj < UserObj
  @[GObject::Property]
  property crystal_prop2 = ""

  def initialize
    super
  end
end

private abstract class AbstractUserObj < GObject::Object
end

private class NonAbstractUserObj < AbstractUserObj
end

describe "Crystal GObjects" do
  it "can born in C land" do
    ptr = LibGObject.g_object_new(UserObj.g_type, "crystal_prop1", "value", Pointer(Void).null)
    user_obj = UserObj.new(ptr, :none)
    user_obj.crystal_prop1.should eq("value")
    user_obj.crystal_attr.should eq(42)
    user_obj.ref_count.should eq(1)
  end

  it "works with types hierarchy" do
    ptr = LibGObject.g_object_new(InheritedUserObj.g_type, "crystal_prop1", "value1", "crystal_prop2", "value2", Pointer(Void).null)
    user_obj = UserObj.new(ptr, :none)
    user_obj.crystal_prop1.should eq("value1")
    inherited_obj = InheritedUserObj.cast?(user_obj)
    inherited_obj.should_not eq(nil)
    inherited_obj.not_nil!.crystal_prop2.should eq("value2")
  end

  it "works with abstract classes in hierarchy" do
    NonAbstractUserObj.new
  end
end
