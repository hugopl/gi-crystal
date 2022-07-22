require "./spec_helper"

describe "Struct bindings" do
  it "do not generate setters for struct pointer attributes" do
    truct = Test::Struct.new(begin: 42)
    truct.responds_to?(:point_ptr=).should eq(false)
    truct.point_ptr.should eq(nil)
  end

  it "can have structs as attributes" do
    truct = Test::Struct.new(begin: 42)
    truct.point.should eq(Test::Point.new(0, 0))
    truct.point = Test::Point.new(1, 2)
    truct.point.should be_a(Test::Point)
    truct.point.x.should eq(1)
    truct.point.y.should eq(2)
  end

  it "binds POD structs with other POD structs as a Crystal struct" do
    rect = Test::Rect.new
    rect.is_a?(Value).should eq(true)

    two_points = Test::TwoPoints.new
    two_points.is_a?(Value).should eq(true)
  end

  it "ignore fields according to binding.yml" do
    truct = Test::Struct.new
    truct.responds_to?(:ignored_field).should eq(false)
    truct.responds_to?(:ignored_field=).should eq(false)
  end

  it "can have nullable string attributes" do
    truct = Test::Struct.new
    truct.string.should eq(nil)
    truct._initialize
    truct.string.should eq("hey")
  end

  it "can bind initialize/finalize methods" do
    truct = Test::Struct.new
    truct.responds_to?(:_initialize).should eq(true)
    truct.responds_to?(:_finalize).should eq(true)
  end
end
