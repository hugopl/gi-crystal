require "./spec_helper"

# Used on basic signal tests
class GlobalVar
  class_property value = ""
end

# Used on basic signal tests
def full_notify_slot(gobj : GObject::Object, param_spec : GObject::ParamSpec) : Nil
  GlobalVar.value = "#{GlobalVar.value}\nfull_notify_slot called #{gobj.to_unsafe}".strip
end

# Used on basic signal tests
def lean_notify_slot(param_spec : GObject::ParamSpec) : Nil
  GlobalVar.value = "#{GlobalVar.value}\nlean_notify_slot called".strip
end

describe "GObject Binding" do
  after_each do
    # Run GC twice just to be sure any bug on object destruction is caught.
    # Why 5 times? No idea... I was just unsure of doing just a single call.
    5.times { GC.collect }
  end

  describe "binding configuration" do
    describe "method removal" do
      it "removes GLib.g_get_environ" do
        GLib.responds_to?(:host_name).should eq(false)
      end
    end
  end

  describe "basic properties" do
    it "works with strings" do
      subject = Test::Subject.new
      subject.string = "hey ho"
      subject.string.should eq("hey ho")
    end
  end

  describe "getters" do
    it "bind get_foo as foo if foo has no params" do
      subject = Test::Subject.new
      subject.getter_without_args.should eq("some string")
    end
  end

  describe "setters" do
    subject = Test::Subject.new
    subject.setter = "hello man!"
    subject.string.should eq("hello man!")
  end

  describe "flags" do
    it "can be passed as arguments and returned by value" do
      subject = Test::Subject.new
      ret = subject.return_or_on_flags(:option1, :option2)
      ret.option1?.should eq(true)
      ret.option2?.should eq(true)
      ret.should eq(Test::FlagFlags::All)
      ret.none?.should eq(false)
      ret = subject.return_or_on_flags(:none, :option2)
      ret.should eq(Test::FlagFlags::Option2)
    end
  end

  describe "interfaces" do
    it "can be returned by methods" do
      subject = Test::Subject.new
      myself = subject.return_myself_as_interface
      subject.string.should eq("test_subject_return_myself_as_interface")
      subject.to_unsafe.should eq(myself.to_unsafe)
    end
  end

  describe "structs" do
    it "can be returned by transfer full (boxed structs)" do
      boxed = Test::BoxedStruct.return_boxed_struct("hell yeah!")
      boxed.data.should eq("hell yeah!")
    end

    it "can be returned by transfer none" do
      boxed = Test::BoxedStruct.return_boxed_struct("boxed")

      ret = boxed.return_transfer_none
      ret.data.should eq("boxed")
      ret.to_unsafe.should eq(boxed.to_unsafe)
    end
  end

  describe "glist" do
    it "works on transfer full" do
      subject = Test::Subject.new
      list = subject.return_list_of_strings_transfer_full
      list.size.should eq(2)
      list.first?.should eq("one")
      list.last?.should eq("two")
    end

    it "works on transfer none" do
      subject = Test::Subject.new
      list = subject.return_list_of_strings_transfer_container
      list.size.should eq(2)
      list.first?.should eq("one")
      list.last?.should eq("two")
    end

    it "can be converted to an array" do
      subject = Test::Subject.new
      list = subject.return_list_of_strings_transfer_container
      list.to_a.should eq(%w(one two))
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

  describe "signals" do
    it "can receive details and connect to a block" do
      subject = Test::Subject.new
      prop_changed = false
      subject.notify_signal["string"].connect do
        prop_changed = true
      end
      GlobalVar.value = ""
      subject.string = "new value"
      prop_changed.should eq(true)
    end

    it "can receive details and connect to a non-closure slot without receiving the sender" do
      subject = Test::Subject.new
      subject.notify_signal["string"].connect(->lean_notify_slot(GObject::ParamSpec))
      GlobalVar.value = ""
      subject.string = "new value"
      GlobalVar.value.should eq("lean_notify_slot called")
    end

    it "can receive details and connect to a non-closure slot receiving the sender" do
      subject = Test::Subject.new
      subject.notify_signal["string"].connect(->full_notify_slot(GObject::Object, GObject::ParamSpec))
      GlobalVar.value = ""
      subject.string = "new value"
      GlobalVar.value.should eq("full_notify_slot called #{subject.to_unsafe}")
    end

    it "can connecy a after signal" do
      subject = Test::Subject.new
      subject.notify_signal["string"].connect_after(->lean_notify_slot(GObject::ParamSpec))
      subject.notify_signal["string"].connect(->full_notify_slot(GObject::Object, GObject::ParamSpec))
      GlobalVar.value = ""
      subject.string = "new value"
      GlobalVar.value.should eq("full_notify_slot called #{subject.to_unsafe}\n" \
                                "lean_notify_slot called")
    end
  end

  describe "raw C arrays" do
    it "works with nil" do
      subject = Test::Subject.new
      subject.concat_strings(nil).should eq("")
    end

    it "can be received in arguments as Array" do
      subject = Test::Subject.new
      subject.concat_strings(%w(lets go)).should eq("letsgo")
    end

    it "can be received in arguments as Tuple" do
      subject = Test::Subject.new
      subject.concat_strings({"hey", "ho"}).should eq("heyho")
    end

    describe "of filenames" do
      it "can be received in arguments as Array(String)" do
        subject = Test::Subject.new
        subject.concat_filenames(%w(lets go)).should eq("letsgo")
      end

      it "can be received in arguments as Tuple(String)" do
        subject = Test::Subject.new
        subject.concat_filenames({"hey", "ho"}).should eq("heyho")
      end
      pending "can be received as argument as Array(Path)"
      pending "can be received as argument as Tuple(Path)"
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
