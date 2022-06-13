module GObject
  class ParamSpec
    # Returns ParamSpec reference counter.
    def ref_count : UInt32
      to_unsafe.as(Pointer(LibGObject::ParamSpec)).value.ref_count
    end
  end

  class ParamSpecInt < ParamSpec
    # :nodoc:
    def initialize(name : String, nick : String, blurb : String,
                   minimum : Int32, maximum : Int32, default_value : Int32, flags : ParamFlags)
      # This constructor will probably not exist in the future since I plan to implement some macros to declare
      # GObject properties.
      ptr = LibGObject.g_param_spec_int(name, nick, blurb, minimum, maximum, default_value, flags)
      super(ptr, :full)
    end

    # TODO: Add getters for fields in ParamSpecInt
    # TODO: Add a way to cast a ParamSpec and remove `ParamSpec#cast(GObject::Object)`
  end
end
