require "./spec_helper"

describe "GObject flags" do
  it "can be passed as arguments and returned by value" do
    subject = Test::Subject.new
    ret = subject.return_or_on_flags(:option1, :option2)
    ret.option1?.should eq(true)
    ret.option2?.should eq(true)
    ret.should eq(Test::FlagFlags::All)
    ret.none?.should eq(false)
    ret = subject.return_or_on_flags(:none, :option2)
    ret.should eq(Test::FlagFlags::Option2)
  end

  it "are transformed into enums when they only have the None element" do
    Test::Subject.receive_empty_flags(:none).should eq(Test::EmptyFlags::None)
  end

  it "ignore bad values" do
    ret = Test::Subject.return_bad_flag
    ret.option1?.should eq(true)
    ret.option2?.should eq(false)
    ret.none?.should eq(false)
    ret.to_i.should eq(17)
  end

  it "can be ignored in binding.yml" do
    {% if parse_type("Test::IgnoredFlags").resolve? %}
      true.should eq(false), "Test::IgnoredFlags was not ignored."
    {% end %}
  end
end
