require "./spec_helper"
describe GICrystal::ClosureDataManager do
  it "can print info about registered pointers" do
    GC.collect
    buffer = IO::Memory.new
    GICrystal::ClosureDataManager.info(buffer)
    buffer.to_s.should eq("total closures on hold: 0\n")

    buffer.clear
    ptr = "some value".to_unsafe.as(Pointer(Void))
    GICrystal::ClosureDataManager.register(ptr)
    GICrystal::ClosureDataManager.info(buffer)
    buffer.to_s.should end_with("total closures on hold: 1\n")

    buffer.clear
    GICrystal::ClosureDataManager.register(ptr)
    GICrystal::ClosureDataManager.info(buffer)
    buffer.to_s.should end_with("total closures on hold: 1\n")

    buffer.clear
    GICrystal::ClosureDataManager.deregister(ptr)
    GICrystal::ClosureDataManager.info(buffer)
    buffer.to_s.should end_with("total closures on hold: 1\n")

    buffer.clear
    GICrystal::ClosureDataManager.deregister(ptr)
    GICrystal::ClosureDataManager.info(buffer)
    buffer.to_s.should end_with("total closures on hold: 0\n")
  end
end
