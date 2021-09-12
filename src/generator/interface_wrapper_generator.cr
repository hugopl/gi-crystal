module Generator
  class InterfaceWrapperGenerator < Base
    include WrapperUtil

    @namespace : Namespace
    @iface_info : InterfaceInfo

    def initialize(@namespace : Namespace, @iface_info : InterfaceInfo)
    end

    def filename : String?
      "#{@iface_info.name.underscore}.cr"
    end

    def subject : String
      @iface_info.name
    end

    private def do_generate(io : IO)
      iface_name = to_lib_type(@iface_info, include_namespace: false)
      io << "module " << to_type_name(@namespace.name) << LF
      doc_repo.doc(io, @iface_info)
      io << "module " << iface_name << LF
      MethodWrapperGenerator.generate(io, @iface_info.methods)
      PropertyWrapperGenerator.generate(io, @iface_info.properties)
      io << "end\n\n"
      io << "# :nodoc:\n"
      io << "class " << iface_name << "__Impl\n"
      io << "  include " << iface_name << "\n"
      io << "  @pointer : Pointer(Void)\n" \
            "  @transfer : GICrystal::Transfer\n" \
            "\n" \
            "  def initialize(@pointer, @transfer)\n" \
            "    LibGObject.g_object_ref(self) unless transfer.full?\n" \
            "  end\n" \
            "\n" \
            "  def finalize\n" \
            "    LibGObject.g_object_unref(@pointer) if @transfer.full?\n" \
            "  end\n" \
            "\n" \
            "  def to_unsafe\n" \
            "    @pointer\n" \
            "  end\n"

      generate_ref_count(io)

      io << "end\n" \
            "end\n"
    end
  end
end
