require "./spec_helper"

describe "GError" do
  it "can be in return values" do
    error = Test::Subject.return_g_error
    error.class.should eq(GLib::FileError::Failed)
    error.message.should eq("whatever message")
  end

  it "are translated to exceptions" do
    obj = Test::Subject.new
    expect_raises(GLib::FileError::Failed, "An error with ♥️") do
      obj.raise_file_error
    end
  end

  it "are translated to exceptions (2)" do
    obj = Test::Subject.new
    expect_raises(GLib::FileError::Failed, "An error with ♥️") do
      obj.raise_file_error2(2)
    end
  end
end
