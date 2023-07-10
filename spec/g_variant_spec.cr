require "./spec_helper"

describe "GVariant" do
  context "when used as in parameter" do
    it { Test::Subject.g_variant_parameter("hey").should eq("'hey'") }
    it { Test::Subject.g_variant_parameter(32).should eq("32") }
    it { Test::Subject.g_variant_parameter(33_u32).should eq("uint32 33") }
    it { Test::Subject.g_variant_parameter(64_i64).should eq("int64 64") }
    it { Test::Subject.g_variant_parameter(65_u64).should eq("uint64 65") }
    it { Test::Subject.g_variant_parameter(16_i16).should eq("int16 16") }
    it { Test::Subject.g_variant_parameter(17_u16).should eq("uint16 17") }
    it { Test::Subject.g_variant_parameter(true).should eq("true") }
    it { Test::Subject.g_variant_parameter(false).should eq("false") }
    it { Test::Subject.g_variant_parameter(0.5).should eq("0.5") }
    it { Test::Subject.g_variant_parameter(1.0_f32).should eq("1.0") }
    it { Test::Subject.g_variant_parameter(GLib::Variant.new("ho")).should eq("'ho'") }
    it { Test::Subject.g_variant_parameter(%w(hey ho)).should eq("['hey', 'ho']") }
    it { Test::Subject.g_variant_parameter({"hey", "ho"}).should eq("['hey', 'ho']") }

    it "can be nullable" do
      Test::Subject.g_variant_parameter(nil).should eq("NULL")
    end
  end

  it "can be used as a signal parameter" do
    subject = Test::Subject.new
    test_variant = nil
    subject.variant_signal.connect do |variant|
      test_variant = variant
    end

    subject.variant_signal.emit(42)
    test_variant.not_nil!.as_i.should eq(42)
  end

  it "have a string representation" do
    v = GLib::Variant.new("hey")
    v.to_s.should eq("'hey'")
    v = GLib::Variant.new(42_u64)
    v.to_s.should eq("uint64 42")
    v.to_s(false).should eq("42")
  end

  it "can parse text representations of GVariant's" do
    v = GLib::Variant.new("hey")
    GLib::Variant.parse(v.to_s).should eq(v)

    v = GLib::Variant.new(42_u64)
    GLib::Variant.parse(v.to_s).should eq(v)
  end

  context "respond to as_* and as_*?" do
    it { GLib::Variant.new(8_u8).as_u8.should eq(8_u8) }
    it { GLib::Variant.new(16_i16).as_i16.should eq(16_i16) }
    it { GLib::Variant.new(17_u16).as_u16.should eq(17_u16) }
    it { GLib::Variant.new(32).as_i.should eq(32) }
    it { GLib::Variant.new(32).as_i32.should eq(32) }
    it { GLib::Variant.new(33_u32).as_u32.should eq(33_u32) }
    it { GLib::Variant.new(64_i64).as_i64.should eq(64_i64) }
    it { GLib::Variant.new(65_u64).as_u64.should eq(65_u64) }
    it { GLib::Variant.new(0.5).as_f.should eq(0.5) }
    it { GLib::Variant.new(1.0).as_f64.should eq(1.0) }
    it { GLib::Variant.new(true).as_bool.should eq(true) }
    it { GLib::Variant.new(false).as_bool.should eq(false) }
    it { GLib::Variant.new("hey").as_s.should eq("hey") }
  end

  pending "can be used in return values"
end
