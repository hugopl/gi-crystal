require "./generator"

module Generator
  abstract class FileGen < Generator
    abstract def filename : String

    def generate
      output_dir = File.join(Generator.output_dir, module_dir)
      FileUtils.mkdir_p(output_dir)

      File.open(File.join(output_dir, filename), "w") do |io|
        generate(io)
      end
    end
  end
end
