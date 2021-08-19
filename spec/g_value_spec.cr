require "./spec_helper"

describe "GValue" do
  context "when used as parameter in an array" do
    it "can convert integer types" do
      res = Test::Subject.new.array_of_g_values(-12, 34_u32, 56_i64, 78_u64)
      res.should eq("gint:-12;guint:34;gint64:56;guint64:78;")
    end

    it "can convert float types" do
      res = Test::Subject.new.array_of_g_values(3.14, 5.67_f32)
      res.should eq("gdouble:3.14;gfloat:5.67;")
    end

    it "can convert strings" do
      res = Test::Subject.new.array_of_g_values("hey", "ho")
      res.should eq("gchararray:hey;gchararray:ho;")
    end

    pending "can convert objects"
  end

  pending "when use as parameter"
  pending "when in a return value"
end
