require "log"

require "../gobject_introspection"
require "./module_wrapper_generator"

module Generator
  class Error < RuntimeError
  end

  LF  = "\n"
  Log = ::Log.for("generator")

  def generate(options : NamedTuple)
    DocRepo.disable! unless options[:doc_gen]

    gen = ModuleWrapperGenerator.load(options[:namespace], options[:version])
    gen.generate(options[:output_dir])
    gen.dependencies.each(&.generate(options[:output_dir]))
    format_files(options[:output_dir])
  end

  private def format_files(dir)
    # We need to chdir into output dir since the formatter ignores everything under `lib` dir.
    Dir.cd(dir) { `crystal tool format` }
    raise Error.new("Error formating generated files at '#{dir}'.") unless $?.success?
  end

  extend self
end
