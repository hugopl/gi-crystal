require "spec"

require "../build/test-1.0/test"

class SpecException < RuntimeError
end

module GLib
  macro method_missing(call)
    raise SpecException.new({{ call.id }})
  end
end
