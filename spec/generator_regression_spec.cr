require "spec"

# These tests verify the generator produces valid Crystal code.
# They read the generated binding files and check for known bug patterns.
describe "Generator regression tests" do
  describe "nullable parameter transformation" do
    # This test guards against the bug where NullableArrayPlan generated:
    #   nullable = if nullable.nil?
    # Which Crystal rejects with "can't use variable name inside assignment"
    #
    # The fix generates:
    #   _nullable = if nullable.nil?
    # And uses _nullable in the C call.
    it "uses transformed variable name for nullable parameters" do
      # Read the generated code for Subject#receive_nullable_object
      generated_file = File.join(__DIR__, "..", "src", "generated", "test-1.0", "subject.cr")
      content = File.read(generated_file)

      # Find the receive_nullable_object method
      method_start = content.index("def receive_nullable_object")
      method_start.should_not be_nil

      # Extract the method body (until next def or end of class)
      method_end = content.index(/\n    def /, method_start.not_nil! + 1) || content.size
      method_body = content[method_start.not_nil!...method_end]

      # Verify it uses _nullable (the fixed pattern)
      method_body.should contain("_nullable = if nullable.nil?")

      # Verify the C call uses _nullable
      method_body.should contain("_nullable)")

      # Verify it does NOT use the broken pattern (variable assigned to itself)
      # This pattern would cause: "can't use variable name 'nullable' inside assignment to variable 'nullable'"
      # Note: We check for the exact broken pattern as a string
      (method_body =~ /\bnullable = if nullable\.nil\?/).should be_nil
    end
  end
end
