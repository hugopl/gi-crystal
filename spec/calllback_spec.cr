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

describe "Callback parameters with C arrays" do
  # Bug: `ArrayArgPlan#generate_c_to_crystal_implementation` (src/generator/arg_strategy.cr), used for arguments
  # received by callbacks, signal handlers and vfuncs, always casts the C array to `Pointer(Pointer(Void))`, even for
  # arrays of integers, floats or structs. For arrays of primitive types the generated trampoline doesn't even
  # compile (a `Pointer(Void)` is stored in an `Array(Int32)`); for arrays of structs (e.g. `Gio::InputMessage` in
  # `Gio::DatagramBased` vfuncs) it compiles and treats the struct contents as pointers, reading 8 bytes per
  # element: garbage values and reads past the end of the C array (out of bounds read, may crash). Also:
  #
  # - `if array_len > 0` should be `>= 0`, when the length argument is the first argument (index 0) the generated
  #   trampoline is just `raise NotImplementedError.new`, raised from inside a C frame.
  # - The callback alias (e.g. `Test::IntArrayFunc`) still includes the array length argument, but the trampoline
  #   unboxes the proc without it (`Proc(Enumerable(Int32), Nil)`), so the user proc is called with a wrong
  #   signature. The length argument must be removed from the alias, as it's already removed from the call.
  #
  # Fix: read the array using its real element type (`Pointer(Int32)` here), convert each element according to
  # its type and accept a length argument at any position.
  pending "receives arrays of primitive types" do
    subject = Test::Subject.new
    received = [] of Int32
    subject.call_int_array_func(->(values : Enumerable(Int32)) { received.concat(values); nil })
    received.should eq([10, 20, 30, 40])

    received.clear
    subject.call_int_array_length_first_func(->(values : Enumerable(Int32)) { received.concat(values); nil })
    received.should eq([10, 20, 30, 40])
  end
end
