module GLib
  # Gets the real name of the user. This usually comes from the user’s entry in the passwd file.
  # If the real user name cannot be determined, the string “Unknown” is returned.
  # The real user name is always interpreted as a UTF-8 string with invalid bytes removed.
  def real_name : String
    _retval = LibGLib.g_get_real_name
    ::String.new(_retval).scrub
  end
end
