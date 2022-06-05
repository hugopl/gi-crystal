describe GLib::VariantDict do
  it "#lookup_value can return nil" do
    dict = GLib::VariantDict.new(nil)
    dict.lookup_value("foo", GLib::VariantType.new("s")).should eq(nil)
  end
end
