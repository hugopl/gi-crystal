require "./spec_helper"

describe GLib::Bytes do
  it "data method return a Slice" do
    original_data = "hey ho lets go"
    g_bytes = GLib::Bytes.new(original_data.to_unsafe, original_data.bytesize)
    String.new(g_bytes.data.not_nil!).should eq(original_data)
  end
end
