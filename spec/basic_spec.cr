require "./spec_helper"

class SubjectChildStore
  getter subject

  def initialize
    @subject = Test::SubjectChild.new_constructor("hello")
  end
end

describe "GObject Binding" do
  it "generate @[Deprecated] annotations on deprecated methods" do
    deprecated_methods = [] of String
    {% for method in Test::Subject.methods %}
      {% if method.annotation(Deprecated) %}
        deprecated_methods << {{ method.name.stringify }}
      {% end %}
    {% end %}
    deprecated_methods.should eq(%w(deprecated_method))
  end

  describe "reference counting" do
    it "accessible by ref_count method" do
      subject = Test::Subject.new(boolean: true)
      subject.ref_count.should eq(1)
      iface = subject.return_myself_as_interface
      iface.object_id.should eq(subject.object_id)
      subject.ref_count.should eq(1)
    end

    it "increase object reference when passing it to a transfer full method" do
      subject = Test::Subject.new(boolean: true)
      subject.ref_count.should eq(1)
      Test::Subject.transfer_full_param(subject)
      subject.ref_count.should eq(2)

      # be nice and don't leak ref on tests
      LibGObject.g_object_unref(subject)
    end

    it "increase object reference when passing it to a nullable transfer full parameter" do
      subject = Test::Subject.new(boolean: true)
      Test::Subject.nullable_transfer_full_param(nil)

      subject.ref_count.should eq(1)
      Test::Subject.nullable_transfer_full_param(subject)
      subject.ref_count.should eq(2)
      # be nice and don't leak ref on tests
      LibGObject.g_object_unref(subject)
    end

    it "increase object reference when passing it to a nullable transfer full interface parameter" do
      subject = Test::Subject.new(boolean: true)
      Test::Subject.nullable_transfer_full_iface_param(nil)

      subject.ref_count.should eq(1)
      Test::Subject.nullable_transfer_full_iface_param(subject)
      subject.ref_count.should eq(2)
      # be nice and don't leak ref on tests
      LibGObject.g_object_unref(subject)
    end

    it "sink float references on constructors" do
      ref = Test::FloatRef.new
      LibGObject.g_object_is_floating(ref).should eq(0)
      ref.ref_count.should eq(1)
    end

    it "sink float references on properties constructor" do
      ref = Test::FloatRef.new(foo: 42)
      LibGObject.g_object_is_floating(ref).should eq(0)
      ref.ref_count.should eq(1)
    end

    it "sink float references on custom constructors" do
      ref = Test::FloatRef.new_with_foo(42)
      LibGObject.g_object_is_floating(ref).should eq(0)
      ref.ref_count.should eq(1)
    end
  end

  describe "binding configuration" do
    describe "method removal" do
      it "removes GLib.g_get_environ" do
        GLib.responds_to?(:host_name).should eq(false)
      end
    end
  end

  describe "constructors" do
    it "generate alternative constructors" do
      subject = Test::Subject.new_from_string("hello")
      subject.string.should eq("hello")
    end

    it "generate renamed constructors" do
      subject = Test::SubjectChild.new("hello")
      subject.class.should eq(Test::SubjectChild)
      subject.string.should eq("hello")
    end

    it "returns the right type instead of any base type" do
      store = SubjectChildStore.new
      typeof(store.subject).should eq(Test::SubjectChild)
      store.subject.string.should eq("hello")
    end

    it "may return nil" do
      subject = Test::SubjectChild.new_constructor_returning_null("hello")
      typeof(subject).should eq(Test::SubjectChild | Nil)
      subject.should eq(nil)
    end
  end

  describe "casts" do
    it "don't use wrapper cache" do
      ptr = LibGObject.g_object_new(Test::SubjectChild.g_type, "string", "hey", "int32", 42, Pointer(Void).null)
      obj = GObject::Object.new(ptr, :full)
      subject = Test::SubjectChild.cast(obj)
      # If these pointers are equal, they are the same Crystal object, with luck it may not crash, but
      # it can crash because the crystal type id is for GObject::Object instead of Test::SubjectChild.
      #
      # Note that if the type is an user type, these pointers must be the same!
      obj.as(Void*).should_not eq(subject.as(Void*))
    end

    it "can be used on interfaces" do
      ptr = LibGObject.g_object_new(Test::Subject.g_type, "float64", 0.5, Pointer(Void).null)
      obj = GObject::Object.new(ptr, :full)
      iface = Test::Iface.cast(obj)
      iface.float64.should eq(0.5)
      iface.ref_count.should eq(2)
      iface.return_myself_as_interface.float64.should eq(0.5)
    end

    it "can downcast objects" do
      child = Test::SubjectChild.new(string: "hey")
      gobj = child.me_as_gobject
      gobj.ref_count.should eq(2) # we can't reuse the crystal wrapper of non-user objects
      gobj.class.should eq(Test::SubjectChild)
      cast = Test::Subject.cast(gobj)
      cast.ref_count.should eq(3)
      cast.string.should eq("hey")
      child.should eq(gobj)
      cast.should eq(gobj)
    end

    it "thrown an exception on bad casts" do
      expect_raises(TypeCastError) { Test::SubjectChild.cast(Test::Subject.new) }
    end

    it "return new on bad casts using cast?" do
      Test::SubjectChild.cast?(Test::Subject.new).should eq(nil)
    end
  end

  describe "getters" do
    it "bind get_foo as foo if foo has no params" do
      subject = Test::Subject.new
      subject.getter_without_args.should eq("some string")
    end

    it "removes out params" do
      subject = Test::Subject.new
      ret = subject.out_param
      ret.in.should eq(1)
      ret.begin.should eq(2)
    end
  end

  describe "setters" do
    subject = Test::Subject.new
    subject.setter = "hello man!"
    subject.string.should eq("hello man!")
  end

  describe "enums" do
    it "works" do
      Test::RegularEnum::Value1.to_i.should eq(0)
      Test::RegularEnum::Value2.to_i.should eq(1)
      Test::RegularEnum::Value3.to_i.should eq(2)
    end
  end

  describe "constants" do
    it "can have a value annotation" do
      Test::CONSTANT_WITH_VALUE_ANNOTATION.should eq(100)
    end

    it "works" do
      Test::CONSTANT.should eq(123)
    end
  end

  describe "nullable parameters" do
    it "can receive nil" do
      subject = Test::Subject.new
      subject.receive_nullable_object(nil).should eq(1)
    end

    it "can receive nil" do
      subject = Test::Subject.new
      subject.receive_nullable_object(subject).should eq(0)
    end

    it "are hidden when also optional" do
      subject = Test::Subject.new
      subject.nullable_optimal_parameter.should eq(42)
    end
  end

  describe "return values" do
    it "can be nullable" do
      subject = Test::Subject.new
      subject.may_return_null(true).should eq(nil)
      subject.may_return_null(false).not_nil!.to_unsafe.should eq(subject.to_unsafe)
    end
  end

  describe "array of uint8 parameters" do
    it "are translated to Crystal ::Bytes" do
      contents = File.read(File.join(__DIR__, "./resource.xml"))
      mime = Gio.content_type_guess("file.ui", contents.to_slice)
      mime.should eq("application/x-designer")
    end
  end

  describe "optional parameters" do
    it "are removed" do
      Test::Subject.no_optional_param.should eq(0)
    end
  end

  describe "parameters named using Crystal keywords" do
    it "works on gobject parameters" do
      subject = Test::Subject.new
      subject.receive_arguments_named_as_crystal_keywords(1, 2, 3, 4, 5, 6, 7, 8, 9).should eq(45)
    end

    it "works on plain structs" do
      subject = Test::Struct.new(begin: 42)
      subject.begin.should eq(42)
    end
  end
end
