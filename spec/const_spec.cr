require "./spec_helper"

describe "constant bindings" do
  it "ignores constants according to binding.yml" do
    responds = true
    {% unless Test.has_constant? :IGNORED_CONSTANT %}
      responds = false
    {% end %}
    responds.should eq(false)
  end

  it "doesn't ignore all constants" do
    responds = false
    {% if Test.has_constant? :NON_IGNORED_CONSTANT %}
      responds = true
    {% end %}
    responds.should eq(true)
  end

  it "bind false Boolean constants" do
    Test::BOOLEAN_FALSE_CONSTANT.should eq(false)
  end

  it "bind true Boolean constants" do
    Test::BOOLEAN_TRUE_CONSTANT.should eq(true)
  end
end
