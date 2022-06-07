require "colorize"
require "log"
require "option_parser"
require "version_from_shard"
require "compiler/crystal/tools/formatter"

require "./module_gen"
require "./binding_config"
require "./error"

VersionFromShard.declare

private def project_dir
  exe_path = Process.executable_path
  raise Generator::Error.new("Can't find gi-crystal executable path.") if exe_path.nil?

  Path.new(exe_path).parent.parent
end

private def parse_options(argv)
  output_dir = nil
  doc_gen = true

  OptionParser.parse(argv) do |parser|
    parser.banner = "Usage: generator [binding-config]"
    parser.on("-h", "--help", "Show this help") do
      puts parser
      exit
    end
    parser.on("--version", "Show gi-crystal version") do
      puts "Gi Crystal version #{VERSION} built with Crystal #{Crystal::VERSION}."
      exit
    end
    parser.on("-o=DIRECTORY", "Output directory, default: \"lib/gi-crystal/src/auto\"") do |dir|
      output_dir = Path.new(dir).expand.to_s
    end
    parser.on("--no-doc", "Disable documentation generation on generated code") { doc_gen = false }

    parser.invalid_option do |flag|
      abort("#{flag} is not a valid option.\n\n#{parser}")
    end
  end

  output_dir = Path.new(project_dir, "lib/gi-crystal/src/auto").normalize if output_dir.nil?
  extra_bindings = argv.map { |path| Path.new(path).expand.to_s }

  {output_dir:     output_dir,
   doc_gen:        doc_gen,
   extra_bindings: extra_bindings}
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

  stdout_backend = Log::IOBackend.new(formatter: formatter, dispatcher: :direct)
  log_level = ENV["LOG_LEVEL"]? ? Log::Severity.parse(ENV["LOG_LEVEL"]) : Log::Severity::Info
  Log.setup do |conf|
    conf.bind("*", log_level, stdout_backend)
  end
end

private def find_bindings : Array(String)
  find_pattern = Path.new(project_dir, "**/binding.yml").normalize
  Dir[find_pattern]
end

private def generate_all
  Generator::BindingConfig.loaded_configs.each_value do |conf|
    module_gen = Generator::ModuleGen.load(conf)
    output_dir = File.join(module_gen.output_dir, module_gen.module_dir)
    FileUtils.mkdir_p(output_dir)
    generated = String.build { |io| module_gen.generate(io) }
    formatted = Crystal.format(generated)
    File.write(File.join(output_dir, module_gen.filename), formatted)
  end
end

private def main(argv)
  setup_logger

  options = parse_options(argv)
  Log.info { "Starting at #{Time.local}, project dir: #{project_dir}" }
  Generator::Generator.output_dir = options[:output_dir].to_s
  Log.info { "Generating bindings at #{options[:output_dir]}" }

  Generator::DocRepo.disable! unless options[:doc_gen]

  binding_yamls = find_bindings.concat(options[:extra_bindings])
  binding_yamls.each { |file| Log.info { "Using binding config at #{file}" } }

  Generator::BindingConfig.load(binding_yamls)

  generate_all
rescue e : Generator::Error | GObjectIntrospection::Error | File::NotFoundError
  Log.fatal(exception: e) { e.message }
  puts e.backtrace.join("\n") if ENV["DEBUG"]?
  exit(1)
end

main(ARGV)
