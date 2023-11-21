require "./spec_helper"

describe "GSList" do
  it "works with interfaces" do
    subject = Test::Subject.new(string: "Subject from Crystal")

    list = subject.return_slist_of_iface_transfer_full
    list.size.should eq(2)

    list[0].object_id.should eq(subject.object_id)
    Test::Subject.cast(list[0]).string.should eq("Subject from Crystal")
    Test::Subject.cast(list[1]).string.should eq("Subject from C")
  end

  it "works with GObjects" do
    subject = Test::Subject.new(string: "Subject from Crystal")

    list = subject.return_slist_of_gobject_transfer_full
    list.size.should eq(2)

    list[0].object_id.should eq(subject.object_id)
    list[0].as(Test::Subject).string.should eq("Subject from Crystal")
    Test::Subject.cast(list[0]).string.should eq("Subject from Crystal")

    list[1].as(Test::Subject).string.should eq("Subject from C")
    Test::Subject.cast(list[1]).string.should eq("Subject from C")
  end

  it "works on transfer full" do
    subject = Test::Subject.new
    list = subject.return_slist_of_strings_transfer_full
    list.size.should eq(2)
    list[0].should eq("one")
    list[1].should eq("two")
  end

  it "works on transfer none" do
    subject = Test::Subject.new
    list = subject.return_slist_of_strings_transfer_container
    list.size.should eq(2)
    list[0].should eq("one")
    list[1].should eq("two")
  end

  it "can be converted to an array" do
    subject = Test::Subject.new
    list = subject.return_slist_of_strings_transfer_container
    list.to_a.should eq(%w(one two))
  end

  it "has .each method" do
    subject = Test::Subject.new
    list = subject.return_list_of_strings_transfer_container
    res = [] of String
    list.each { |s| res << s }
    res.should eq(%w(one two))
  end
end
