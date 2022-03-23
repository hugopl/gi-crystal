require "./spec_helper"

describe "Glib timeout & idle_add" do
  it "compiles 😅️" do
    GLib.timeout(1.second) do
      false
    end

    GLib.idle_add do
      false
    end
  end
end
