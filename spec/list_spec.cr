require "./spec_helper"

describe "GList" do
  it "works with interfaces" do
    subject = Test::Subject.new(string: "Born in Crystal")

    list = subject.return_list_of_iface_transfer_full
    list.size.should eq(2)

    subject_from_c = list[0]
    subject_from_c.object_id.should eq(subject.object_id)
    Test::Subject.cast(subject_from_c).string.should eq("Born in Crystal")
    Test::Subject.cast(list[1]).string.should eq("Born in C")
  end

  it "works with GObjects" do
    subject = Test::Subject.new(string: "Born in Crystal")

    list = subject.return_list_of_gobject_transfer_full
    list.size.should eq(2)

    subject_from_c = list[0]
    subject_from_c.object_id.should eq(subject.object_id)
    Test::Subject.cast(subject_from_c).string.should eq("Born in Crystal")
    Test::Subject.cast(list[1]).string.should eq("Born in C")
  end

  it "works on transfer full" do
    subject = Test::Subject.new
    list = subject.return_list_of_strings_transfer_full
    list.size.should eq(2)
    list.first?.should eq("one")
    list.last?.should eq("two")
    list[0].should eq("one")
    list[1].should eq("two")
  end

  it "works on transfer none" do
    subject = Test::Subject.new
    list = subject.return_list_of_strings_transfer_container
    list.size.should eq(2)
    list.first?.should eq("one")
    list.last?.should eq("two")
  end

  it "can be converted to an array" do
    subject = Test::Subject.new
    list = subject.return_list_of_strings_transfer_container
    list.to_a.should eq(%w(one two))
  end

  it "has .each method" do
    subject = Test::Subject.new
    list = subject.return_list_of_strings_transfer_container
    res = [] of String
    list.each { |s| res << s }
    res.should eq(%w(one two))
  end

  describe "ListStore" do
    it "can splice an array" do
      list_store = Gio::ListStore.new(Test::Subject.g_type)
      one = Test::Subject.new
      items = [one]
      list_store.splice(position: 0_u32, n_removals: 0_u32, additions: items)
    end
  end
end
