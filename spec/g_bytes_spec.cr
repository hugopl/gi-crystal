require "./spec_helper"

describe GLib::Bytes do
  it "can be used as return value with transfer none" do
    data = "Hey ho!"
    bytes = Test::Subject.string_to_bytes_transfer_none(data)
    bytes.size.should eq(data.bytesize)
    String.new(bytes.data.not_nil!).should eq(data)
  end

  it "can be used as return value with transfer full" do
    data = "Hey ho!"
    bytes = Test::Subject.string_to_bytes_transfer_full(data)
    bytes.size.should eq(data.bytesize)
  end

  {% if compare_versions("#{GLib::MAJOR_VERSION}.#{GLib::MINOR_VERSION}.#{GLib::MICRO_VERSION}", "2.70.0") >= 0 %}
    it "can fetch a region of memory" do
      data = "Hey ho!"
      bytes = Test::Subject.string_to_bytes_transfer_none(data)
      region = bytes.region(3, 4, 1)
      region.should_not eq(nil)
      String.new(region.not_nil!.as(Pointer(UInt8)), 3).should eq("ho!")
    end
  {% end %}
end
