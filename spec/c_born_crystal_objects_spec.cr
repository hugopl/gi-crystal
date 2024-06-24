require "./spec_helper"

private class UserObj < GObject::Object
  @[GObject::Property]
  property crystal_prop = ""
  getter crystal_attr : Int32 = 42

  def initialize
    super
  end
end

describe "Crystal GObjects" do
  it "can born in C land" do
    ptr = LibGObject.g_object_new(UserObj.g_type, "crystal_prop", "value", Pointer(Void).null)
    user_obj = UserObj.new(ptr, :none)
    user_obj.crystal_prop.should eq("value")
    user_obj.crystal_attr.should eq(42)
    user_obj.ref_count.should eq(1)
  end
end
