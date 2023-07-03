# This file includes the function GC_malloc_uncollectable from bdwgc.
# It enables us to allocate a block of memory which will not be freed,
# but which will be scanned for pointers to collectible objects.
# This allows storing pointers to crystal objects in GObject subclasses.

{% if flag?(:gc_none) || flag?(:wasm32) %}
  module GC
    # :nodoc:
    def self.malloc_uncollectable(size : LibC::SizeT) : Void*
      LibC.malloc(size)
    end
  end
{% else %}
  lib GICrystal_LibGC
    fun malloc_uncollectable = GC_malloc_uncollectable(size : LibC::SizeT) : Void*
  end

  module GC
    # :nodoc:
    def self.malloc_uncollectable(size : LibC::SizeT) : Void*
      GICrystal_LibGC.malloc_uncollectable(size)
    end
  end
{% end %}

module GC
  # Allocates *size* bytes of uncollectable memory.
  #
  # The resulting object may contain pointers and they will be tracked by the GC.
  #
  # The memory will not be automatically deallocated when unreferenced.
  def self.malloc_uncollectable(size : Int) : Void*
    malloc_uncollectable(LibC::SizeT.new(size))
  end
end
