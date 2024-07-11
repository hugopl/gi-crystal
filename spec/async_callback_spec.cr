require "./spec_helper"

describe "Gio async callbacks" do
  it "works" do
    mainloop = GLib::MainLoop.new(GLib::MainContext.default, true)
    block_called = false

    file = Gio::File.new_for_path(__FILE__)
    file.read_async(0, nil) do |obj, result|
      obj.as(Gio::File).read_finish(result)
      block_called = true
      mainloop.quit
    end

    mainloop.run
    block_called.should eq(true)
  end
end
