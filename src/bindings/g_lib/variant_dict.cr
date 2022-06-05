module GLib
  class VariantDict
    def lookup_value(key : ::String, expected_type : GLib::VariantType?) : GLib::Variant?
      # See https://gitlab.gnome.org/GNOME/glib/-/merge_requests/2719 for why this 🐒️ patch exists.
      expected_type = if expected_type.nil?
                        Pointer(Void).null
                      else
                        expected_type.to_unsafe
                      end
      retval = LibGLib.g_variant_dict_lookup_value(@pointer, key, expected_type)
      GLib::Variant.new(retval, GICrystal::Transfer::Full) if retval
    end
  end
end
