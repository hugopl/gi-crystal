require "./spec_helper"

# Used on basic signal tests
def full_notify_slot(gobj : GObject::Object) : Nil
  GlobalVar.value = "#{GlobalVar.value}\nfull_notify_slot called #{gobj.to_unsafe}".strip
end

# Used on basic signal tests
def lean_notify_slot : Nil
  GlobalVar.value = "#{GlobalVar.value}\nlean_notify_slot called".strip
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
    subject.notify_signal["string"].connect(->lean_notify_slot)
    GlobalVar.value = ""
    subject.string = "new value"
    GlobalVar.value.should eq("lean_notify_slot called")
  end

  it "can receive details and connect to a non-closure slot receiving the sender" do
    subject = Test::Subject.new
    subject.notify_signal["string"].connect(->full_notify_slot(GObject::Object))
    GlobalVar.value = ""
    subject.string = "new value"
    GlobalVar.value.should eq("full_notify_slot called #{subject.to_unsafe}")
  end

  it "can connecy a after signal" do
    subject = Test::Subject.new
    subject.notify_signal["string"].connect_after(->lean_notify_slot)
    subject.notify_signal["string"].connect(->full_notify_slot(GObject::Object))
    GlobalVar.value = ""
    subject.string = "new value"
    GlobalVar.value.should eq("full_notify_slot called #{subject.to_unsafe}\n" \
                              "lean_notify_slot called")
  end
end
