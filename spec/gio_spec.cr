require "./spec_helper"

describe Gio do
  it "can register and fetch resources" do
    resource = Gio.register_resource("spec/resource.xml", source_dir: "spec")
    resource_bytes = resource.lookup_data("/spec/gio_spec.cr")
    String.new(resource_bytes.data.not_nil!).should eq(File.read(__FILE__))
  end
end
