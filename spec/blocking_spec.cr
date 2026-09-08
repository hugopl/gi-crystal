require "./spec_helper"

describe "methods declared with blocks: true" do
  it "run in a isolated execution context" do
    Test::Subject.block_thread(1000).should_not eq(Test::Subject.current_thread)
  end

  it "do not block fibers in the default execution context" do
    ticks = 0
    running = true
    spawn do
      while running
        ticks += 1
        sleep 1.millisecond
      end
    end

    Test::Subject.block_thread(100_000)
    running = false
    ticks.should be > 1
  end
end
