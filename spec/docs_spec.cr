require "./spec_helper"

describe "Docs conversion" do
  it "converted the docs to crystal" do
    expected_results = {
      "# getter: `Test::Subject#out_param`",
      "# setter: `Test::Subject#str_list=`",
      "# is: `Test::Subject#is_bool?`",
      "# initializer: `Test::Subject.new`",
      "# WARNING: **⚠️ The following code is in c ⚠️**",
      "# `nil` `true` `false`",
      "# `Gdk::VulkanContext` Adw::ComboRow",
      "# parameter: *parameter_42*",
      "# email_is_not_a_parameter: foo@example.com",
    }

    test_subject = File.read("./src/generated/test-1.0/subject.cr")

    expected_results.each do |doc|
      test_subject.should contain(doc)
    end
  end
end
