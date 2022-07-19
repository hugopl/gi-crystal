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
