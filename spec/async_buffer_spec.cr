require "./spec_helper"

# Forces GC cycles and allocates garbage, so memory freed by the GC gets reused and overwritten.
private def stress_gc
  5.times do
    GC.collect
    200.times { Array(Int64).new(16, 0x4141414141414141_i64) }
  end
end

private def iterate_main_loop_until(&)
  context = GLib::MainContext.default
  1000.times do
    break if yield

    stress_gc
    context.iteration(false)
  end
end

# Starts a sum_bytes_async call without keeping any reference to the buffer in Crystal land.
@[NoInline]
private def sum_bytes_async_with_dropped_buffer(subject : Test::Subject, results : Array(UInt32)) : Nil
  bytes = Bytes.new(1024, 1_u8)
  subject.sum_bytes_async(bytes, nil) do |obj, result|
    results << Test::Subject.cast(obj.not_nil!).sum_bytes_finish(result)
  end
end

describe "GIO async methods with buffer arguments" do
  # Bug: `generate_array_to_unsafe` (src/generator/wrapper_util.cr) converts array arguments with
  # `buffer.to_a.to_unsafe`, i.e. C receives a pointer to a temporary copy of the user's `Bytes`. For async
  # functions the C side keeps reading (or writing) the buffer until the callback is called, but the temporary
  # copy becomes garbage as soon as the `*_async` method returns. The GC then reuses that memory, so C reads
  # garbage (e.g. `Gio::OutputStream#write_async` would write garbage to the stream) or writes into memory now
  # owned by another object (heap corruption).
  #
  # Fix: pass the user's buffer directly when its memory layout already matches the C type (e.g. `Bytes`,
  # `Slice`/`Array` of numbers) instead of copying it, and keep a reference to the buffer alive until the async
  # callback is called (e.g. store it along with the callback box). The user is still expected not to modify the
  # buffer while the operation is running.
  pending "keeps the buffer alive until the operation finishes" do
    subject = Test::Subject.new
    results = [] of UInt32
    10.times { sum_bytes_async_with_dropped_buffer(subject, results) }

    iterate_main_loop_until { results.size == 10 }
    results.should eq([1024_u32] * 10)
  end
end
