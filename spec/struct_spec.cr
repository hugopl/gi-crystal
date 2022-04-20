require "./spec_helper"

describe "Struct bindings" do
  it "can have struct pointers as attributes" do
    truct = Test::Struct.new(begin: 42)
    truct.point_ptr.should eq(nil)
    truct.point_ptr = Test::Point.new(1, 2)
    truct.point_ptr.should be_a(Test::Point)
    truct.point_ptr!.x.should eq(1)
    truct.point_ptr!.y.should eq(2)
    truct.point_ptr = nil
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
    truct = Test::Struct.new(string: "hey")
    truct.string.should eq("hey")
  end
end
