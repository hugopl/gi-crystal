require "./generator"

module Generator
  abstract class FileGen < Generator
    abstract def filename : String

    def generate
      generate(filename)
    end
  end
end
