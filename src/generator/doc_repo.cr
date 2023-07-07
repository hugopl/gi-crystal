require "xml"
require "log"

module Generator
  # TODO: This still very incomplete, but at least isn't slow as hell and can enable very good docs in the future.
  # TODO: Write method/param docs
  # TODO: Write module docs
  # TODO: How gtk-doc sections would fit here?
  class DocRepo
    include GObjectIntrospection

    @doc : XML::Node?

    @@disabled : DocRepo?
    @@repos = Hash(String, DocRepo).new

    def self.for(namespace : Namespace) : DocRepo
      disabled = @@disabled
      return disabled if disabled

      @@repos[namespace.name] ||= DocRepo.new(namespace.name, namespace.version)
    end

    def self.disable!
      @@disabled = DummyDocRepo.new
    end

    def initialize(name, version)
      gir_filename = "#{name}-#{version}.gir"
      search_paths.each do |path|
        xml_filename = File.join(path, gir_filename)
        next unless File.exists?(xml_filename)

        @doc = load_xml(xml_filename)
        if @doc
          Log.debug { "Documentation for #{name}-#{version} from: #{xml_filename}" }
          return
        end
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

    def doc(io : IO, info, subinfo) : Nil
      return if @doc.nil?

      xpath = xpath(info, subinfo)
      print_doc(io, xpath) if xpath
    end

    def doc(io : IO, info) : Nil
      return if @doc.nil?

      xpath = xpath(info)
      print_doc(io, xpath) if xpath
    end

    def xpath(obj : RegisteredTypeInfo, signal : SignalInfo)
      "/xmlns:repository/xmlns:namespace/xmlns:class[@name=\"#{obj.name}\"]" \
      "/glib:signal[@name=\"#{signal.name}\"]/xmlns:doc[1]"
    end

    private def xpath(enum_info : EnumInfo, value : ValueInfo)
      "/xmlns:repository/xmlns:namespace/xmlns:enumeration[@name=\"#{enum_info.name}\"]/" \
      "xmlns:member[@name=\"#{value.name}\"]/xmlns:doc[1]"
    end

    private def xpath(obj : ObjectInfo)
      "/xmlns:repository/xmlns:namespace/xmlns:class[@name=\"#{obj.name}\"]/xmlns:doc[1]"
    end

    private def xpath(obj : StructInfo)
      "/xmlns:repository/xmlns:namespace/xmlns:record[@name=\"#{obj.name}\"]/xmlns:doc[1]"
    end

    private def xpath(interface : InterfaceInfo)
      "/xmlns:repository/xmlns:namespace/xmlns:interface[@name=\"#{interface.name}\"]/xmlns:doc[1]"
    end

    private def xpath(const : ConstantInfo)
      "/xmlns:repository/xmlns:namespace/xmlns:constant[@name=\"#{const.name}\"]/xmlns:doc[1]"
    end

    private def xpath(enum_ : EnumInfo)
      "/xmlns:repository/xmlns:namespace/xmlns:enumeration[@name=\"#{enum_.name}\"]/xmlns:doc[1]"
    end

    private def xpath(callback : CallbackInfo)
      "/xmlns:repository/xmlns:namespace/xmlns:callback[@name=\"#{callback.name}\"]/xmlns:doc[1]"
    end

    private def xpath(obj : RegisteredTypeInfo, func : FunctionInfo)
      func_flags = func.flags
      type = case func_flags
             when .method?      then "method"
             when .constructor? then "constructor"
             when .none?        then "function"
             else
               return
             end
      "/xmlns:repository/xmlns:namespace/xmlns:class[@name=\"#{obj.name}\"]" \
      "/xmlns:#{type}[@name=\"#{func.name}\"]/xmlns:doc[1]"
    end

    private def xpath(obj : Namespace, func : FunctionInfo)
    end

    def crystallize_doc(doc : String) : String
      crystallized_doc = doc
      crystallized_doc = crystallized_doc.gsub(/```([a-zA-Z]+)\n/, "\n\nWARNING: **⚠️ The following code is in \\1 ⚠️**\n```\\1\n")
      crystallized_doc = crystallized_doc.gsub(/\s@(\w[\w\d_]*)\b/, " *\\1*")
      crystallized_doc = crystallized_doc.gsub(/%(TRUE|FALSE|NULL)/) do |_, match|
        case match[1]
        when "TRUE"  then "`true`"
        when "FALSE" then "`false`"
        when "NULL"  then "`nil`"
        end
      end

      crystallized_doc = crystallized_doc.gsub(/\[([a-zA-Z]+)@([a-zA-Z\.:_]+)\]/) do |_, match|
        split_reference = match[-1].split(/\.|:/)
        identifier = split_reference[-1]
        identifier = if match[0] == "ctor" || identifier == "new"
                       ".#{identifier}"
                     elsif identifier.starts_with?("get_") && identifier.size > 4
                       "##{identifier[4..]}"
                     elsif identifier.starts_with?("is_") && identifier.size > 3
                       "##{identifier}?"
                     elsif identifier.starts_with?("set_") && identifier.size > 4
                       "##{identifier[4..]}="
                     else
                       "#{split_reference.size == 2 ? "::" : "#"}#{identifier}"
                     end

        "`#{split_reference[0..-2].join("::")}#{identifier}`"
      end

      # FIXME: Get this list of modules form the generator itself instead of hardcode them
      crystallized_doc = crystallized_doc.gsub(/(G[dts]k|Pango|cairo_|graphene_|Adw|Hdy|GtkSource)(\w+\b)/) do |_, match|
        match.captures.join("::")
      end

      crystallized_doc
    end

    private def print_doc(io : IO, xpath : String)
      doc = fetch_doc(xpath)
      return if doc.nil?

      crystallize_doc(doc).each_line do |line|
        io << "# "
        io.puts(line)
      end
    end

    private def fetch_doc(xpath : String) : String?
      doc = @doc
      doc.try &.xpath_string("string(#{xpath})")
    end
  end

  class DummyDocRepo < DocRepo
    def initialize
    end

    def doc(io, info) : Nil
    end

    def doc(io, obj1, obj2) : Nil
    end
  end
end
