require "log"

require "../gobject_introspection"
require "./module_wrapper_generator"

module Generator
  class Error < RuntimeError
  end

  LF = "\n"
  Log = ::Log.for("generator")

  def generate(namespace : String, version : String?, output_dir : String)
    gen = ModuleWrapperGenerator.load(namespace, version)
    gen.generate(output_dir)
    gen.dependencies.each(&.generate(output_dir))
    format_files(output_dir)
  end

  private def format_files(dir)
    # We need to chdir into output dir since the formatter ignores everything under `lib` dir.
    Dir.cd(dir) { `crystal tool format` }
    raise Error.new("Error formating generated files at '#{dir}'.") unless $?.success?
  end

  extend self
end
