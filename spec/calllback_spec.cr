require "./spec_helper"

def simple_callback(obj, value) : Nil
  GlobalVar.value = "called with #{obj.class.name} instance and #{value}!"
end

describe "Callback parameters" do
  it "do not remove last callback argument unless it is a pointer" do
    Test::SubjectCallbackWithPointer.should eq(Proc(Pointer(Void), GObject::Object, Bool, Nil))
  end

  it "can be set" do
    subject = Test::Subject.new
    subject.simple_func = ->simple_callback(Test::Subject, Int32)
    subject.call_simple_func(42).should eq(true)
    GlobalVar.value.should eq("called with Test::Subject instance and 42!")
  end

  it "can be reset" do
    subject = Test::Subject.new
    subject.simple_func = nil
    subject.call_simple_func(42).should eq(false)
  end
end

describe "Callback return values" do
  it "are converted back to C, for objects" do
    subject = Test::Subject.new
    returned = Test::Subject.new
    subject.call_object_func(-> { returned.as(GObject::Object) }).should eq(returned)
  end

  it "are converted back to C, for booleans" do
    subject = Test::Subject.new
    subject.call_bool_func(-> { true }).should eq(true)
    subject.call_bool_func(-> { false }).should eq(false)
  end
end
