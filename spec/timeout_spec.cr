require "./spec_helper"

describe "Glib timeout & idle_add" do
  it "compiles 😅️" do
    GLib.timeout(1.second) do
      false
    end

    GLib.idle_add do
      false
    end

    # We still with 2 refs here because no main loop was run to free them
    GICrystal::ClosureDataManager.count.should eq(2)
    GICrystal::ClosureDataManager.deregister_all
  end
end
