module Gio
  # Load the XML *resource_file* and register it, returning the `Gio::Resource`.
  #
  # When compiling in release mode this macro runs `glib-compile-resources` at compile time, so the XML is only needed at
  # compile time. However when running in debug mode this macro runs `glib-compile-resources` at run time, so you don't
  # need to recompile your program to e.g. see the changes in a UI file inside a GResource.
  #
  # By default the *resource_file* is read from the same directory where the compiler was invoked, to read it from
  # a different directory use the *sourcedir* parameter.
  #
  # See `examples/resource.cr` for more info.
  macro register_resource(resource_file, source_dir = ".")
    begin
      {% if flag?(:release) %}
      {%
        `glib-compile-resources --sourcedir #{source_dir} --target crystal-gio-resource.gresource #{resource_file}`
        data = read_file("crystal-gio-resource.gresource")
        # FIXME: This wont work on windows
        `rm crystal-gio-resource.gresource`
      %}
      %resource_data = {{ data }}
      {% else %}
        `glib-compile-resources --sourcedir #{{{source_dir}}} --target crystal-gio-resource.gresource #{{{resource_file}}}`
        %resource_data = File.read("crystal-gio-resource.gresource")
        File.delete("crystal-gio-resource.gresource")
      {% end %}
      %gbytes = LibGLib.g_bytes_new_static(%resource_data, %resource_data.bytesize)
      %error = Pointer(LibGLib::Error).null
      %resource_ptr = LibGio.g_resource_new_from_data(%gbytes, pointerof(%error))
      Gio.raise_gerror(%error) unless %error.null?

      Gio::Resource.new(%resource_ptr, :full).tap do |%resource|
        %resource._register
      end
    end
  end

  class Resource
    # Same as `lookup_data(path, :none)`.
    def lookup_data(path : ::String) : GLib::Bytes
      lookup_data(path, :none)
    end
  end
end
