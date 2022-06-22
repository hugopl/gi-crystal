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

private class UserObjectWithGProperties < GObject::Object
  @[GObject::Property(nick: "STRING", blurb: "A string without meaning", default: "default")]
  property str_ing : String = "default"

  @[GObject::Property(nick: "INTEGER", blurb: "An Int32", default: 42, min: 40, max: 50)]
  property int : Int32 = 42

  @[GObject::Property(default: TestFlags::BC)]
  property flags = TestFlags::BC

  @[GObject::Property]
  property object : UserObject? = nil

  @[GObject::Property]
  getter signal_test : Bool = true
  @[GObject::Property]
  setter signal_test : Bool = true
end

class User::Class::With::Colons < GObject::Object
end

describe "Classes inheriting GObject::Object" do
  it "can register object with complicated class path (issue #29)" do
    User::Class::With::Colons.g_type.should_not eq(0)
  end

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

  it "can set GObject properties" do
    obj = UserObjectWithGProperties.new

    out_string = LibGObject::Value.new
    LibGObject.g_value_init(pointerof(out_string), GObject::TYPE_STRING)
    LibGObject.g_value_set_string(pointerof(out_string), "test value")
    LibGObject.g_object_set_property(obj, "str-ing", pointerof(out_string))
    LibGObject.g_value_unset(pointerof(out_string))
    obj.str_ing.should eq("test value")

    out_int = LibGObject::Value.new
    LibGObject.g_value_init(pointerof(out_int), GObject::TYPE_INT)
    LibGObject.g_value_set_int(pointerof(out_int), 50)
    LibGObject.g_object_set_property(obj, "int", pointerof(out_int))
    LibGObject.g_value_unset(pointerof(out_int))
    obj.int.should eq(50)

    out_flags = LibGObject::Value.new
    LibGObject.g_value_init(pointerof(out_flags), GObject::TYPE_FLAGS)
    LibGObject.g_value_set_flags(pointerof(out_flags), TestFlags::C)
    LibGObject.g_object_set_property(obj, "flags", pointerof(out_flags))
    LibGObject.g_value_unset(pointerof(out_flags))
    obj.flags.should eq(TestFlags::C)

    object = UserObject.new
    out_object = LibGObject::Value.new
    LibGObject.g_value_init(pointerof(out_object), GObject::TYPE_OBJECT)
    LibGObject.g_value_set_object(pointerof(out_object), object.to_unsafe)
    LibGObject.g_object_set_property(obj, "object", pointerof(out_object))
    LibGObject.g_value_unset(pointerof(out_object))
    obj.object.should_not eq(nil)
    obj.object.not_nil!.to_unsafe.should eq(object.to_unsafe)
  end

  it "can get GObject properties" do
    obj = UserObjectWithGProperties.new

    out_string = LibGObject::Value.new
    LibGObject.g_object_get_property(obj, "str-ing", pointerof(out_string))
    GObject::Value.raw(GObject::TYPE_STRING, pointerof(out_string).as(Void*)).as(String?).should eq("default")
    LibGObject.g_value_unset(pointerof(out_string))
    obj.str_ing = "test value"
    LibGObject.g_object_get_property(obj, "str-ing", pointerof(out_string))
    GObject::Value.raw(GObject::TYPE_STRING, pointerof(out_string).as(Void*)).as(String?).should eq("test value")
    LibGObject.g_value_unset(pointerof(out_string))

    out_int = LibGObject::Value.new
    LibGObject.g_object_get_property(obj, "int", pointerof(out_int))
    GObject::Value.raw(GObject::TYPE_INT, pointerof(out_int).as(Void*)).should eq(42)
    LibGObject.g_value_unset(pointerof(out_int))
    obj.int = 50
    LibGObject.g_object_get_property(obj, "int", pointerof(out_int))
    GObject::Value.raw(GObject::TYPE_INT, pointerof(out_int).as(Void*)).should eq(50)
    LibGObject.g_value_unset(pointerof(out_int))

    obj.flags = TestFlags::A
    out_flags = LibGObject::Value.new
    LibGObject.g_object_get_property(obj, "flags", pointerof(out_flags))
    GObject::Value.raw(GObject::TYPE_FLAGS, pointerof(out_flags).as(Void*)).should eq(TestFlags::A.value)
    LibGObject.g_value_unset(pointerof(out_flags))

    obj.object = UserObject.new
    out_object = LibGObject::Value.new
    LibGObject.g_object_get_property(obj, "object", pointerof(out_object))
    GObject::Value.raw(GObject::TYPE_OBJECT, pointerof(out_object).as(Void*)).should eq(obj.object)
    LibGObject.g_value_unset(pointerof(out_object))
  end

  it "emits notify signal on GObject properties access" do
    test_var = 0
    obj = UserObjectWithGProperties.new
    signal = obj.notify_signal["signal-test"].connect { test_var += 1 }

    test_var.should eq(0)
    obj.signal_test = false
    test_var.should eq(1)
    obj.signal_test = true
    test_var.should eq(2)

    signal.disconnect
  end
end
