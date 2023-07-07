require "./spec_helper"

private class UserSignalObj < GObject::Object
  signal no_args
  signal uint32(uint32 : UInt32)
  signal int64(int64 : Int64, uint64 : UInt64)
  signal floats(float : Float32, double : Float64)
  signal string(str : String)
  signal path(path : Path)
  signal bool(value : Bool)
end

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
    subject.notify_signal["string"].connect(->lean_notify_slot(GObject::ParamSpec), after: true)
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

  it "can have boolean parameters and return value" do
    subject = Test::Subject.new
    subject.return_bool_signal.connect do |value|
      typeof(value).should be_a(Bool)
      value
    end
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

  it "can have Interface as parameter" do
    subject = Test::Subject.new

    received_obj : Test::Iface? = nil
    subject.iface_signal.connect do |obj|
      received_obj = obj
    end

    obj = Test::Subject.new
    subject.iface_signal.emit(obj)
    received_obj.should eq(obj)
  end

  it "can have array Interface as parameter" do
    subject = Test::Subject.new
    obj1 = Test::Subject.new
    obj2 = Test::Subject.new
    # FIXME: Changing the line bellow to `received_objs2 = nil` will crash the compiler
    #        However I can't reduce the issue to a minimal code 😢️
    received_objs = [] of Test::Iface
    subject.array_of_iface_signal.connect do |objs|
      received_objs = objs
    end

    subject.array_of_iface_signal.emit([obj1, obj2])
    received_objs.should eq([obj1, obj2])
  end

  it "can have a string as parameter" do
    subject = Test::Subject.new
    received_str = ""
    subject.nullable_args_signal.connect do |signal_str|
      received_str = signal_str
    end

    subject.nullable_args_signal.emit("Olá", 0)
    received_str.should eq("Olá")
  end

  it "can have an enum as parameter" do
    subject = Test::Subject.new
    received_enum = Test::RegularEnum::Value1
    subject.enum_signal.connect do |_enum|
      received_enum = _enum
    end

    subject.enum_signal.emit(:value2)
    received_enum.should eq(Test::RegularEnum::Value2)
  end

  it "can have a boxed struct as parameter" do
    subject = Test::Subject.new
    received_boxed = nil
    subject.boxed_signal.connect do |box|
      received_boxed = box
    end

    box = Test::BoxedStruct.return_boxed_struct("hey")
    subject.boxed_signal.emit(box)
    received_boxed.not_nil!.data.should eq("hey")
  end

  it "can have a GValue as parameter" do
    subject = Test::Subject.new
    received_value = nil
    subject.gvalue_signal.connect do |value|
      received_value = value
    end

    subject.gvalue_signal.emit(42)
    received_value.should eq(GObject::Value.new(42))

    subject.gvalue_signal.emit(nil)
    received_value.should eq(nil)
  end

  it "can have a GError as parameter" do
    subject = Test::Subject.new
    received_error = nil
    subject.gerror_signal.connect do |error|
      received_error = error
    end

    error = GLib::ConvertError::Failed.new("test")
    subject.gerror_signal.emit(error)
    received_error.class.should eq(GLib::ConvertError::Failed)
    received_error.not_nil!.message.should eq("test")
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

  context "when declaring signals" do
    it "they have a name" do
      obj = UserSignalObj.new
      obj.uint32_signal.name.should eq("uint32")
    end

    it "works no parameters" do
      obj = UserSignalObj.new
      called = false
      obj.no_args_signal.connect { called = true }
      obj.no_args_signal.emit
      called.should eq(true)
    end

    it "works with (U)Int32 parameters" do
      obj = UserSignalObj.new
      value = 0
      obj.uint32_signal.connect do |v|
        value = v
      end

      obj.uint32_signal.emit(32)
      value.should eq(32)
    end

    it "works with (U)Int64 parameters" do
      obj = UserSignalObj.new
      received_i64 = 0_i64
      received_u64 = 0_u64
      obj.int64_signal.connect do |i64, u64|
        received_i64 = i64
        received_u64 = u64
      end

      obj.int64_signal.emit(32_i64, 128_u64)
      received_i64.should eq(32_i64)
      received_u64.should eq(128_u64)
    end

    it "works with Float32 parameters" do
      obj = UserSignalObj.new
      received_f32 = 0.0_f32
      received_f64 = 0.0
      obj.floats_signal.connect do |f32, f64|
        received_f32 = f32
        received_f64 = f64
      end

      obj.floats_signal.emit(3.14_f32, 6.28)
      received_f32.should eq(3.14_f32)
      received_f64.should eq(6.28_f64)
    end

    it "works with String parameters" do
      obj = UserSignalObj.new
      received_str = ""
      obj.string_signal.connect do |str|
        received_str = str
      end

      obj.string_signal.emit("Hello")
      received_str.should eq("Hello")
    end

    it "works with Path parameters" do
      obj = UserSignalObj.new
      received_path = ""
      obj.path_signal.connect do |path|
        received_path = path
      end

      obj.path_signal.emit(Path.new("Hello"))
      received_path.should eq(Path.new("Hello"))
    end

    it "works with Bool parameters" do
      obj = UserSignalObj.new
      received_bool = false
      obj.bool_signal.connect do |bool|
        received_bool = bool
      end

      obj.bool_signal.emit(true)
      received_bool.should eq(true)
      obj.bool_signal.emit(false)
      received_bool.should eq(false)
    end
  end

  context "when disconnecting signals" do
    it "works" do
      subject = Test::Subject.new
      received_enum = Test::RegularEnum::Value1
      connection = subject.enum_signal.connect do |_enum|
        received_enum = _enum
      end

      connection.connected?.should eq(true)
      connection.disconnect
      connection.connected?.should eq(false)
      subject.enum_signal.emit(:value2)
      received_enum.should eq(Test::RegularEnum::Value1)
    end
  end
end
