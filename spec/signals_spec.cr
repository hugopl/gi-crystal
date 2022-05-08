require "./spec_helper"

# Used on basic signal tests
def full_notify_slot(gobj : GObject::Object, pspec : GObject::ParamSpec) : Nil
  prev_value = GlobalVar.value
  GlobalVar.value = "#{prev_value}\n#{pspec.name} changed! full_notify_slot called #{gobj.to_unsafe}.".strip
end

# Used on basic signal tests
def lean_notify_slot(pspec : GObject::ParamSpec) : Nil
  prev_value = GlobalVar.value
  GlobalVar.value = "#{prev_value}\n#{pspec.name} changed! lean_notify_slot called.".strip
end

describe "GObject signals" do
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
    GlobalVar.value.should eq("string changed! lean_notify_slot called.")
  end

  it "can receive details and connect to a non-closure slot receiving the sender" do
    subject = Test::Subject.new
    subject.notify_signal["string"].connect(->full_notify_slot(GObject::Object, GObject::ParamSpec))
    GlobalVar.value = ""
    subject.string = "new value"
    GlobalVar.value.should eq("string changed! full_notify_slot called #{subject.to_unsafe}.")
  end

  it "can connect a after signal" do
    subject = Test::Subject.new
    subject.notify_signal["string"].connect_after(->lean_notify_slot(GObject::ParamSpec))
    subject.notify_signal["string"].connect(->full_notify_slot(GObject::Object, GObject::ParamSpec))
    GlobalVar.value = ""
    subject.string = "new value"
    GlobalVar.value.should eq("string changed! full_notify_slot called #{subject.to_unsafe}.\n" \
                              "string changed! lean_notify_slot called.")
  end

  it "can have signals with nullable parameters" do
    subject = Test::Subject.new
    str = ""
    number = 0
    subject.nullable_args_signal.connect do |signal_str, signal_number|
      str = signal_str
      number = signal_number
    end
    subject.nullable_args_signal.emit(nil, 42)
    str.should eq(nil)
    number.should eq(42)
  end

  it "can return integers" do
    subject = Test::Subject.new
    subject.return_int_signal.connect do
      42
    end
    # TODO: Use this test to test signal accumulators, for now it's just testing if the code compiles
    # subject.return_int_signal.emit
  end

  pending "test emit signals with return values"

  it "can have array GObject as parameter" do
    subject = Test::Subject.new
    obj1 = Test::Subject.new
    obj2 = Test::Subject.new
    received_objs = nil
    subject.array_of_gobj_signal.connect do |objs|
      received_objs = objs
    end

    subject.array_of_gobj_signal.emit([obj1, obj2])
    received_objs.should eq([obj1, obj2])
  end

  it "can have array Interface as parameter" do
    subject = Test::Subject.new
    obj1 = Test::Subject.new
    obj2 = Test::Subject.new
    # FIXME: Changing the line bellow to `received_objs2 = nil` will crash the compiler
    #        However I can't reduce the issue to a minimal code 😢️
    received_objs2 = [] of Test::Iface
    subject.array_of_iface_signal.connect do |objs|
      received_objs2 = objs
    end

    subject.array_of_iface_signal.emit([obj1, obj2])
    received_objs2.should eq([obj1, obj2])
  end

  context "when in interfaces" do
    it "can receive details and connect to a block" do
      iface = Test::Subject.new.return_myself_as_interface
      iface.should be_a(Test::Iface)
      value = 0
      iface.iface_int32_signal.connect do |v|
        value = v
      end
      iface.iface_int32_signal.emit(32)
      value.should eq(32)
    end
  end
end
