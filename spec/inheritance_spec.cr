require "./spec_helper"

private class UserObject < GObject::Object
end

describe "Classes inheriting GObject::Object" do
  it "has their own g_type registered on GLib type system" do
    UserObject.g_type.should_not eq(GObject::Object.g_type)
  end

  it "can be casted" do
    obj = UserObject.new
    casted_obj = UserObject.cast?(obj)
    casted_obj.should_not eq(nil)
    casted_obj.not_nil!.to_unsafe.should eq(obj.to_unsafe)
  end
end
