require "./spec_helper"

describe "Raw C arrays" do
  it "works with nil" do
    subject = Test::Subject.new
    subject.concat_strings(nil).should eq("")
  end

  it "can be received in arguments as Array" do
    subject = Test::Subject.new
    subject.concat_strings(%w(lets go)).should eq("letsgo")
  end

  it "can be received in arguments as Tuple" do
    subject = Test::Subject.new
    subject.concat_strings({"hey", "ho"}).should eq("heyho")
  end

  it "can be zero-terminated in return values" do
    subject = Test::Subject.new
    subject.return_null_terminated_array_transfer_none.should eq(%w(Hello World))
    subject.return_null_terminated_array_transfer_full.should eq(%w(Hello World))
  end

  context "can be non-zero-terminated in return values" do
    it "transfer full" do
      data = Test::Subject.new.return_array_transfer_full
      data.should eq(%w(Hello World))
    end

    it "transfer none" do
      data = Test::Subject.new.return_array_transfer_none
      data.should eq(%w(Hello World))
    end

    it "transfer container" do
      data = Test::Subject.new.return_array_transfer_container
      data.should eq(%w(Hello World))
    end
  end

  describe "of filenames" do
    it "can be received in arguments as Array(String)" do
      Test::Subject.new.concat_filenames(%w(lets go)).should eq(Path.new("letsgo"))
    end

    it "have a overload using a tuple" do
      Test::Subject.new.concat_filenames("hey", "ho", "lets", "go").should eq(Path.new("heyholetsgo"))
    end

    it "can be received in arguments as Tuple(String)" do
      Test::Subject.new.concat_filenames({"hey", "ho"}).should eq(Path.new("heyho"))
    end

    pending "can be received as argument as Array(Path)"
    pending "can be received as argument as Tuple(Path)"
  end

  describe "of primitive types" do
    it "works" do
      subject = Test::Subject.new
      subject.sum(1, 2, 3).should eq(6)
      subject.sum({1, 2, 3}).should eq(6)
      subject.sum([1, 2, 3]).should eq(6)
    end

    it "can be nullable" do
      subject = Test::Subject.new
      subject.sum_nullable(nil).should eq(0)
      subject.sum_nullable(1, 2, 3).should eq(6)
      subject.sum_nullable({1, 2, 3}).should eq(6)
      subject.sum_nullable([1, 2, 3]).should eq(6)
    end
  end
end
