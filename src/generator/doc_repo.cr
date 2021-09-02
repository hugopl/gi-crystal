require "xml"
require "log"

module Generator
  # TODO: This still very incomplete, but at least isn't slow as hell and can enable very good docs in the future.
  # TODO: Write method/param docs
  # TODO: Write enum/flags docs
  # TODO: Write constants docs
  # TODO: Write module docs
  # TODO: How gtk-doc sections would fit here?
  class DocRepo
    include GObjectIntrospection

    @doc : XML::Node?

    @@repos = Hash(String, DocRepo).new

    def self.for(namespace : Namespace) : DocRepo
      @@repos[namespace.name] ||= DocRepo.new(namespace.name, namespace.version)
    end

    def initialize(name, version)
      gir_filename = "#{name}-#{version}.gir"
      search_paths.each do |path|
        xml_filename = File.join(path, gir_filename)
        next unless File.exists?(xml_filename)

        @doc = load_xml(xml_filename)
        return if @doc
      end

      Log.error { "#{gir_filename} not found, skipping documentation generation for #{name}, search path: #{search_paths}." }
    end

    private def search_paths
      search_paths = [] of String
      path = ENV["GI_TYPELIB_PATH"]?
      search_paths.concat(path.split(":")) if path
      search_paths << "/usr/share/gir-1.0/"
    end

    private def load_xml(filename : String)
      options = XML::ParserOptions::NOBLANKS |
                XML::ParserOptions::RECOVER |
                XML::ParserOptions::NOERROR |
                XML::ParserOptions::NOWARNING |
                XML::ParserOptions::NONET
      XML.parse(File.read(filename), options).root || raise Error.new("Gir file with no XML root")
    end

    def doc(io : IO, info : BaseInfo) : Nil
      return if @doc.nil?

      case info
      when ObjectInfo, InterfaceInfo, StructInfo
        xpath = xpath_for(info)
        print_type_doc(io, xpath) if xpath
      else
        return
      end
    end

    private def xpath_for(info : BaseInfo) : String?
      case info
      when ObjectInfo then "/xmlns:repository/xmlns:namespace/xmlns:class[@name=\"#{info.name}\"]/xmlns:doc[1]"
      when StructInfo then "/xmlns:repository/xmlns:namespace/xmlns:record[@name=\"#{info.name}\"]/xmlns:doc[1]"
      when InterfaceInfo then "/xmlns:repository/xmlns:namespace/xmlns:interface[@name=\"#{info.name}\"]/xmlns:doc[1]"
      end
    end

    def print_type_doc(io : IO, xpath : String)
      doc = fetch_doc(xpath)
      print_doc(io, doc) if doc
    end

    private def print_doc(io : IO, doc : String)
      doc.each_line do |line|
        io << "# " << line << LF
      end
    end

    private def fetch_doc(xpath : String) : String?
      doc = @doc
      doc.try &.xpath_string("string(#{xpath})")
    end
  end
end
