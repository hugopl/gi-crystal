require "./spec_helper"

private class UserObject < GObject::Object
end

private class UserFloatRefObject < Test::FloatRef
end

private class UserObjectWithCtor < GObject::Object
  def initialize(@string : String)
    super()
  end
end

private class UserSubject < Test::Subject
  def initialize(string : String)
    super(string: string)
  end
end

describe "Classes inheriting GObject::Object" do
  it "has their own g_type registered on GLib type system" do
    UserObject.g_type.should_not eq(GObject::Object.g_type)
  end

  it "can be casted" do
    obj = UserObject.new
    casted_obj = UserObject.cast(obj)
    casted_obj.object_id.should eq(obj.object_id)
  end

  it "raises on cast of deleted crystal objects" do
    subject = Test::Subject.new
    user_obj = UserObject.new
    subject.gobj = user_obj

    # Pretend the GC collected the object, but add a ref to it, so the
    # unref made by the artificial `finalize` call wont have any effect.
    LibGObject.g_object_ref(user_obj)
    user_obj.finalize

    expect_raises(GICrystal::ObjectCollectedError) do
      UserObject.cast(subject.gobj.not_nil!)
    end
  end

  it "create a crystal instance if the object was born on C world" do
    raw_gobj = LibGObject.g_object_newv(UserObject.g_type, 0, nil)
    wrapper = GObject::Object.new(raw_gobj, :full)
    obj = UserObject.cast(wrapper)
    obj.to_unsafe.should eq(raw_gobj)
    obj.ref_count.should eq(1)

    obj_again = UserObject.cast(wrapper)
    obj_again.object_id.should eq(obj.object_id)
    obj.ref_count.should eq(1)
  end

  it "create a crystal instance if the object with float ref was born on C world" do
    raw_gobj = LibGObject.g_object_newv(UserFloatRefObject.g_type, 0, nil)
    wrapper = GObject::Object.new(raw_gobj, :full)
    obj = UserFloatRefObject.cast(wrapper)
    LibGObject.g_object_is_floating(obj).should eq(0)
    obj.to_unsafe.should eq(raw_gobj)
    obj.ref_count.should eq(1)

    obj_again = UserFloatRefObject.cast(wrapper)
    obj_again.object_id.should eq(obj.object_id)
    obj.ref_count.should eq(1)
  end

  it "can have any constructors" do
    obj = UserObjectWithCtor.new("hey")
    obj.ref_count.should eq(1)
    obj_wrapper = GObject::Object.new(obj.to_unsafe, :full)
    obj_wrapper.class.should eq(UserObjectWithCtor)
    obj2 = UserObjectWithCtor.cast(obj)
    obj2.should eq(obj)
  end

  it "can call parent generic constructors" do
    obj = UserSubject.new("hey")
    LibGObject.g_type_check_instance_is_a(obj, UserSubject.g_type).should eq(1)
    obj.string.should eq("hey")
  end
end
