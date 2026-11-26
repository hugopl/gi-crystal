require "./spec_helper"

describe "Glib timeout & idle_add" do
  it "compiles 😅️" do
    timeout_id = GLib.timeout(1.second) do
      false
    end

    idle_id = GLib.idle_add do
      false
    end

    # We still with 2 refs here because no main loop was run to free them
    GICrystal::ClosureDataManager.count.should eq(2)

    # Remove the sources, so they don't run later in other specs iterating the main loop.
    GLib.source_remove(timeout_id)
    GLib.source_remove(idle_id)
    GICrystal::ClosureDataManager.count.should eq(0)
  end
end
