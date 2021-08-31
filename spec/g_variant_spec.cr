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
  end

  context "respond to as_* and as_*?" do
  end

  pending "can be used in return values"
end
