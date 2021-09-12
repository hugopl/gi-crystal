module Generator
  class InterfaceWrapperGenerator < Base
    include WrapperUtil

    @namespace : Namespace
    @iface : InterfaceInfo

    def initialize(@namespace : Namespace, @iface : InterfaceInfo)
    end

    def filename : String?
      "#{@iface.name.underscore}.cr"
    end

    def subject : String
      @iface.name
    end

    private def do_generate(io : IO)
      iface_name = to_lib_type(@iface, include_namespace: false)
      io << "module " << to_type_name(@namespace.name) << LF
      doc_repo.doc(io, @iface)
      io << "module " << iface_name << LF
      generate_prerequisites(io)

      MethodWrapperGenerator.generate(io, @iface.methods)
      PropertyWrapperGenerator.generate(io, @iface.properties)

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

    private def generate_prerequisites(io : IO)
      namespace = @iface.namespace
      @iface.prerequisites.each do |iface|
        include_namespace = iface.namespace != namespace

        io << "# Pre requisite: " << to_crystal_type(iface, include_namespace: include_namespace) << LF
      end
      io << LF
    end
  end
end
