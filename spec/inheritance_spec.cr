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

  # The foo: 2 at end is to test if we ignore unknown parameters.
  @[GObject::Property(nick: "INTEGER", blurb: "An Int32", default: 42, min: 40, max: 50, foo: 2)]
  property int : Int32 = 42

  @[GObject::Property(default: TestFlags::BC)]
  property flags = TestFlags::BC

  @[GObject::Property]
  property object : UserObject

  @[GObject::Property]
  property signal_test : Bool = true

  @[GObject::Property]
  property? bool : Bool = false

  # This declaration tests if the property is created as readonly if it only have getter?
  @[GObject::Property]
  getter? readonly_bool : Bool = true

  @[GObject::Property]
  property nilable_object : UserObject?

  def initialize
    super
    @object = UserObject.new
  end
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

  # Crystal types created in C world are not supported yet
  pending "creates crystal object for Crystal type born in C world" do
    raw_gobj = LibGObject.g_object_newv(UserObject.g_type, 0, nil)
    wrapper = GObject::Object.new(raw_gobj, :full)
    obj = UserObject.cast(wrapper)
    obj.to_unsafe.should eq(raw_gobj)
    obj.ref_count.should eq(1)

    obj_again = UserObject.cast(wrapper)
    obj_again.object_id.should eq(obj.object_id)
    obj.ref_count.should eq(1)
  end

  pending "creates crystal object for Crystal type with float ref born in C world" do
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

    LibGObject.g_object_set(obj, "str-ing", "test value", Pointer(Void).null)
    obj.str_ing.should eq("test value")

    LibGObject.g_object_set(obj, "int", 50, Pointer(Void).null)
    obj.int.should eq(50)

    LibGObject.g_object_set(obj, "flags", TestFlags::C, Pointer(Void).null)
    obj.flags.should eq(TestFlags::C)

    object = UserObject.new
    LibGObject.g_object_set(obj, "object", object, Pointer(Void).null)
    obj.object.should eq(object)

    LibGObject.g_object_set(obj, "nilable-object", Pointer(Void).null, Pointer(Void).null)
    obj.nilable_object.should eq(nil)
  end

  it "can get GObject properties" do
    obj = UserObjectWithGProperties.new

    out_string = uninitialized Pointer(LibC::Char)
    LibGObject.g_object_get(obj, "str-ing", pointerof(out_string), Pointer(Void).null)
    String.new(out_string).should eq("default")
    obj.str_ing = "test value"
    LibGObject.g_object_get(obj, "str-ing", pointerof(out_string), Pointer(Void).null)
    String.new(out_string).should eq("test value")

    out_int = uninitialized Int32
    LibGObject.g_object_get(obj, "int", pointerof(out_int), Pointer(Void).null)
    out_int.should eq(42)
    obj.int = 50
    LibGObject.g_object_get(obj, "int", pointerof(out_int), Pointer(Void).null)
    out_int.should eq(50)

    obj.flags = TestFlags::A
    out_flags = uninitialized TestFlags
    LibGObject.g_object_get(obj, "flags", pointerof(out_flags), Pointer(Void).null)
    out_flags.should eq(TestFlags::A)

    obj.object = user_obj = UserObject.new
    out_object = uninitialized Pointer(Void)
    LibGObject.g_object_get(obj, "object", pointerof(out_object), Pointer(Void).null)
    out_object.should eq(user_obj.to_unsafe)

    obj.bool = true
    out_bool = uninitialized Int32
    LibGObject.g_object_get(obj, "bool", pointerof(out_bool), Pointer(Void).null)
    GICrystal.to_bool(out_bool).should eq(true)
    obj.bool?.should eq(true)

    obj.bool = false
    LibGObject.g_object_get(obj, "bool", pointerof(out_bool), Pointer(Void).null)
    GICrystal.to_bool(out_bool).should eq(false)
    obj.bool?.should eq(false)
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
