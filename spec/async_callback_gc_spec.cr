require "./spec_helper"

private def wait_until(&block : -> Bool)
  context = GLib::MainContext.default
  deadline = Time.instant + 5.seconds
  until block.call
    raise "Timeout waiting for async operation" if Time.instant > deadline

    context.iteration(true)
  end
end

# Start the async operation in another stack frame, so no references to the callback box are left on the stack.
private def query_name_async(file : Gio::File, results : Array(String)) : Nil
  file.query_info_async("standard::name", :none, 0, nil) do |obj, result|
    info = Gio::File.cast(obj).query_info_finish(result)
    results << info.name.to_s
  end
end

describe "GIO async pattern" do
  it "holds a reference to the callback until it's called" do
    file = Gio::File.new_for_path(__FILE__)
    results = [] of String
    initial_count = GICrystal::ClosureDataManager.count

    query_name_async(file, results)
    GICrystal::ClosureDataManager.count.should eq(initial_count + 1)

    wait_until { results.any? }
    results.should eq(["async_spec.cr"])
    GICrystal::ClosureDataManager.count.should eq(initial_count)
  end

  it "doesn't let the GC collect the callback before it's called" do
    file = Gio::File.new_for_path(__FILE__)
    results = [] of String
    n = 20
    n.times { query_name_async(file, results) }

    # Collect and allocate a lot of memory, so any collected callback box gets overwritten.
    5.times do
      Array.new(50_000) { |i| Box.box(-> { i.to_s }) }
      GC.collect
    end

    wait_until { results.size == n }
    results.should eq(Array.new(n, "async_spec.cr"))
  end
end
