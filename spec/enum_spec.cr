require "./spec_helper"

describe "Enums" do
  it "registers valid gtypes for user enum/flags" do
    TestFlags.g_type.should_not eq(0)
    TestEnum.g_type.should_not eq(0)
    TestEnum.g_type.should_not eq(TestFlags.g_type)
  end

  it "registers valid gtypes for generated enum/flags" do
    Test::RegularEnum.g_type.should_not eq(0)
    Test::FlagFlags.g_type.should_not eq(0)
  end

  it "can be ignored in binding.yml" do
    {% if parse_type("Test::IgnoredEnum").resolve? %}
      true.should eq(false), "Test::IgnoredEnum was not ignored."
    {% end %}
  end

  it "allows retrieving values by name" do
    enum_class : LibGObject::EnumClass* = LibGObject.g_type_class_ref(TestEnum.g_type).as(LibGObject::EnumClass*)
    flags_class : LibGObject::FlagsClass* = LibGObject.g_type_class_ref(TestFlags.g_type).as(LibGObject::FlagsClass*)

    x_enum_ptr = LibGObject.g_enum_get_value_by_name(enum_class, "X").as(LibGObject::EnumValue*)
    x_enum_value = x_enum_ptr.value
    x_enum_value.value.should eq(TestEnum::X.value)
    String.new(x_enum_value.value_name).should eq("X")

    odd_enum_ptr = LibGObject.g_enum_get_value_by_name(enum_class, "Odd_Välue").as(LibGObject::EnumValue*)
    odd_enum_value = odd_enum_ptr.value
    odd_enum_value.value.should eq(TestEnum::Odd_Välue.value)
    String.new(odd_enum_value.value_name).should eq("Odd_Välue")

    bc_enum_ptr = LibGObject.g_flags_get_value_by_name(flags_class, "BC").as(LibGObject::FlagsValue*)
    bc_enum_value = bc_enum_ptr.value
    bc_enum_value.value.should eq(TestFlags::BC.value)
    String.new(bc_enum_value.value_name).should eq("BC")

    LibGObject.g_type_class_unref(enum_class)
    LibGObject.g_type_class_unref(flags_class)
  end

  it "allows retrieving enum values by value" do
    enum_class : LibGObject::EnumClass* = LibGObject.g_type_class_ref(TestEnum.g_type).as(LibGObject::EnumClass*)
    flags_class : LibGObject::FlagsClass* = LibGObject.g_type_class_ref(TestFlags.g_type).as(LibGObject::FlagsClass*)

    x_enum_ptr = LibGObject.g_enum_get_value(enum_class, TestEnum::X).as(LibGObject::EnumValue*)
    x_enum_value = x_enum_ptr.value
    x_enum_value.value.should eq(TestEnum::X.value)
    String.new(x_enum_value.value_name).should eq("X")

    odd_enum_ptr = LibGObject.g_enum_get_value(enum_class, TestEnum::Odd_Välue).as(LibGObject::EnumValue*)
    odd_enum_value = odd_enum_ptr.value
    odd_enum_value.value.should eq(TestEnum::Odd_Välue.value)
    String.new(odd_enum_value.value_name).should eq("Odd_Välue")

    bc_enum_ptr = LibGObject.g_flags_get_first_value(flags_class, TestFlags::BC).as(LibGObject::FlagsValue*)
    bc_enum_value = bc_enum_ptr.value
    bc_enum_value.value.should eq(TestFlags::B.value)
    String.new(bc_enum_value.value_name).should eq("B")

    LibGObject.g_type_class_unref(enum_class)
    LibGObject.g_type_class_unref(flags_class)
  end
end
