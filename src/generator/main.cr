require "option_parser"
require "colorize"

require "./config"
require "./generator"

private def parse_options(argv)
  output_dir = "./build"

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

    parser.invalid_option do |flag|
      abort("#{flag} is not a valid option.\n\n#{parser}")
    end
    abort("Pass the library namespace, e.g. Gtk as argument\n\n#{parser}") if argv.empty?
  end

  {namespace: ARGV[0], version: ARGV[1]?, output_dir: output_dir}
end

def setup_logger
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
    ctx = entry.context[:scope]?
    io << " - " << ctx if ctx
    io << " - " << entry.message
  end

  backend_with_formatter = Log::IOBackend.new(formatter: formatter)
  log_level = ENV["LOG_LEVEL"]? ? Log::Severity.parse(ENV["LOG_LEVEL"]) : Log::Severity::Notice
  Log.setup(log_level, backend_with_formatter)
end

def main(argv)
  setup_logger

  options = parse_options(argv)
  Generator.generate(options[:namespace], options[:version], options[:output_dir])
rescue e : Generator::Error | GObjectIntrospection::Error
  Log.fatal { e.message }
  exit(1)
end

main(ARGV)
