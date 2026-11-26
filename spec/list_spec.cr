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

@[NoInline]
private def create_and_drop_list_of_boxed : Nil
  Test::Subject.new.return_list_of_boxed_transfer_full.size
  nil
end

describe "GList of boxed structs" do
  # Bug: `GLib::List#finalize` and `GLib::SList#finalize` (src/bindings/g_lib/list.cr, slist.cr) free the elements
  # of transfer full lists with `g_object_unref` for GObjects and `g_free` for everything else. Boxed structs must
  # be freed with `g_boxed_free` (their free function also frees their contents, here the `data` string), and
  # ref-counted types like `GVariant` or `GParamSpec` must be unref'd: `g_free` on them frees memory still owned by
  # other references, causing use-after-free/double free crashes.
  #
  # Fix: free each element according to `T`: `g_boxed_free(T.g_type, ptr)` for boxed types, the type specific unref
  # for `GLib::Variant`/`GObject::ParamSpec`, `g_object_unref` for objects/interfaces and `g_free` for strings.
  pending "frees boxed struct elements with their free function" do
    before = Test::BoxedStruct.free_count
    create_and_drop_list_of_boxed
    10.times do
      GC.collect
      100.times { Array(Int32).new(16) }
    end
    (Test::BoxedStruct.free_count - before).should eq(2)
  end
end
