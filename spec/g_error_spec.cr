require "./spec_helper"

describe "GError" do
  it "can be in return values" do
    error = Test::Subject.return_g_error
    error.message.should eq("whatever message")
  end
end
