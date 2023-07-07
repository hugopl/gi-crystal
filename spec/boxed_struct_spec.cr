require "./spec_helper"

@[NoInline]
private def create_boxed : Nil
  Test::BoxedStruct.return_boxed_struct("hey")
end

describe "Boxed Struct bindings" do
  it "doesn't crash on finalize method" do
    create_boxed
    GC.collect
  end
end
