require "./spec_helper"

private class UserObject < GObject::Object
end

private class UserFloatRefObject < Test::FloatRef
end

private class UserObjectWithCtor < GObject::Object
  property string : String = "not hey"
  # def initialize(@string : String)
  #   super()
  # end

  @[NoInline]
  def self.new_to_unsafe(string : String) : Void*
    obj = self.new
    LibGObject.g_object_ref(obj.to_unsafe)
    obj.string = string
    obj.to_unsafe
  end
end

private class UserSubject < Test::Subject
  # def initialize(string : String)
  #   super(string: string)
  # end
end

private class UserObjectWithGProperties < GObject::Object
  @[GObject::Property(nick: "STRING", blurb: "A string without meaning")]
  property str_ing : String = "default"

  @[GObject::Property(nick: "INTEGER", blurb: "An Int32", min: 40, max: 50)]
  property int : Int32 = 42

  @[GObject::Property]
  property flags = TestFlags::BC

  @[GObject::Property]
  property object : UserObject? = nil

  @[GObject::Property]
  property signal_test : Bool = true

  # This declaration tests if the property is created as readonly if it only have getter?
  @[GObject::Property]
  getter? readonly_bool : Bool = true

  @[GObject::Property]
  property nilable_object : UserObject?
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

  # Note that this test is not deterministic.
  # Calling GC.collect will only perform a full collection on high GC pressure.
  # A passing test does not mean it necessarily works.
  it "survive garbage collections" do
    unsafe = UserObjectWithCtor.new_to_unsafe("super random test string")
    GC.collect
    reincarnated_subject = UserObjectWithCtor.new(unsafe, :full)
    reincarnated_subject.string.should eq("super random test string")
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
    obj = UserObjectWithCtor.new
    obj.string = "hey"
    obj.ref_count.should eq(1)
    obj_wrapper = GObject::Object.new(obj.to_unsafe, :full)
    obj_wrapper.class.should eq(UserObjectWithCtor)
    obj2 = UserObjectWithCtor.cast(obj)
    obj2.should eq(obj)
  end

  it "can call parent generic constructors" do
    obj = UserSubject.new
    obj.string = "hey"
    LibGObject.g_type_check_instance_is_a(obj, UserSubject.g_type).should eq(1)
    obj.string.should eq("hey")
  end

  it "can set GObject properties" do
    obj = UserObjectWithGProperties.new
    obj.object = UserObject.new

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
    obj.object = UserObject.new

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
  end

  it "emits notify signal on GObject properties access" do
    test_var = 0
    obj = UserObjectWithGProperties.new
    obj.object = UserObject.new
    signal = obj.notify_signal["signal-test"].connect { test_var += 1 }

    test_var.should eq(0)
    obj.signal_test = false
    test_var.should eq(1)
    obj.signal_test = true
    test_var.should eq(2)

    signal.disconnect
  end
end
