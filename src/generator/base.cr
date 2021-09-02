require "../gobject_introspection"
require "./helpers"
require "./doc_repo"

module Generator
  include GObjectIntrospection

  abstract class Base
    include Generator::Helpers

    @namespace : Namespace
    getter output_dir = "build"

    def initialize(@namespace)
    end

    def config
      Config.for(@namespace.name)
    end

    def doc_repo : DocRepo
      DocRepo.for(@namespace)
    end

    # True if this generator should be ignored.
    def skip?(key : String = subject) : Bool
      config.ignore?(key) || config.handmade?(key)
    end

    # File name created by the the generator or nil if the generator uses a file created by another generator.
    abstract def filename : String?

    # Name of what is being generated, basically BaseInfo#name
    abstract def subject : String

    def generate(@output_dir : String)
      filename = self.filename
      abort("bug") if filename.nil?

      if skip?
        Log.info { "Ignoring #{subject}" }
        return
      end

      File.open(File.join(output_dir, filename), "w") do |io|
        generate(io)
      end
    end

    def generate(io : IO)
      subject = self.subject
      if skip?
        Log.info { "Ignoring #{subject}" }
        return
      end

      Log.context.set(scope: subject)
      do_generate(io)
      Log.context.clear
    end

    protected abstract def do_generate(io : IO)
  end
end
