require "./spec_helper"

describe "Struct bindings" do
  it "can have other structs as attributes" do
    point = Test::Point.new(1, 2)
    truct = Test::Struct.new(begin: 42)
    truct.point.should eq(nil)
    truct.point = point
    truct.point.should be_a(Test::Point)
    truct.point!.x.should eq(1)
    truct.point!.y.should eq(2)
    truct.point = nil
    truct.point.should eq(nil)
  end
end
