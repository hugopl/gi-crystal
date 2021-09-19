require "option_parser"
require "colorize"

require "./module_gen"

private def parse_options(argv)
  output_dir = "./build"
  doc_gen = true

  OptionParser.parse(argv) do |parser|
    parser.banner = "Usage: generator [namespace] [version]"
    parser.on("-h", "--help", "Show this help") do
      puts parser
      exit
    end
    parser.on("-o=OUTPUT_DIRECTORY", "Output directory, default: \"./build\"") do |dir|
      output_dir = Path.new(dir).expand.to_s
    end
    parser.on("--config-paths=PATH", "\":\" separated list of paths to search for config files.") do |path|
      Generator::Config.search_paths = path.split(":").map { |e| Path.new(e) }
    end
    parser.on("--no-doc", "Disable documentation generation on generated code") { doc_gen = false }

    parser.invalid_option do |flag|
      abort("#{flag} is not a valid option.\n\n#{parser}")
    end
    abort("Pass the library namespace, e.g. Gtk as argument\n\n#{parser}") if argv.empty?
  end

  {namespace: ARGV[0], version: ARGV[1]?, output_dir: output_dir, doc_gen: doc_gen}
end

private def setup_logger
  formatter = Log::Formatter.new do |entry, io|
    io << case entry.severity
    in .fatal?  then "fatal".colorize.red
    in .error?  then "error".colorize.red
    in .warn?   then "warn".colorize.yellow
    in .info?   then "info".colorize.green
    in .notice? then "notice".colorize.green
    in .trace?, .debug?, .none?
      entry.severity.to_s.downcase
    end
    ctx = Generator::Generator.log_scope
    io << " - " << ctx if ctx
    io << " - " << entry.message
  end

  backend_with_formatter = Log::IOBackend.new(formatter: formatter, dispatcher: :direct)
  log_level = ENV["LOG_LEVEL"]? ? Log::Severity.parse(ENV["LOG_LEVEL"]) : Log::Severity::Info
  Log.setup(log_level, backend_with_formatter)
end

private def generate(namespace : String, version : String?, output_dir : String, enable_doc_gen : Bool)
  Generator::DocRepo.disable! unless enable_doc_gen

  Generator::Generator.output_dir = output_dir
  gen = Generator::ModuleGen.load(namespace, version)

  gen.generate
  gen.dependencies.each(&.generate)
  format_files(output_dir)
end

private def format_files(dir)
  # We need to chdir into output dir since the formatter ignores everything under `lib` dir.
  Dir.cd(dir) { `crystal tool format` }
  raise Generator::Error.new("Error formating generated files at '#{dir}'.") unless $?.success?
end

private def main(argv)
  setup_logger

  options = parse_options(argv)
  generate(*options.values)
rescue e : Generator::Error | GObjectIntrospection::Error
  Log.fatal { e.message }
  exit(1)
end

main(ARGV)
