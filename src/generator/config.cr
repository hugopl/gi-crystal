require "yaml"

module Generator
  class NamespaceConfig
    getter ignore = Set(String).new
    getter includes = Array(Path).new

    def initialize
    end

    def initialize(any : YAML::Any, yaml_dir : String)
      load_ignore_list(any)
      load_include_list(any, yaml_dir)
    end

    private def load_ignore_list(any)
      ignore = any["ignore"]?
      return if ignore.nil?

      list = ignore.as_a?
      raise Error.new("Ignore key must be a string list.") if list.nil?

      list.each do |item|
        str_item = item.as_s?
        raise Error.new("Ignore key must be a string list.") if str_item.nil?
        Log.warn { "Duplicated item on ignore list: #{str_item}" } if @ignore.includes?(str_item)
        @ignore << str_item
      end
    end

    private def load_include_list(any, yaml_dir)
      includes = any["include"]?
      return if includes.nil?

      include_list = includes.as_a?
      raise Error.new("Ignore key must be a string list.") if include_list.nil?

      include_list.each do |file|
        @includes << Path.new(File.join(yaml_dir, file.as_s)).expand
      end
    end

    def ignore?(name : String) : Bool
      @ignore.includes?(name)
    end
  end

  class Config
    class_property search_paths = [Path.new(Dir.current)]
    @@configs = Hash(String, NamespaceConfig).new
    @@mappings = Hash(String, String).new

    def self.load(namespace : String) : NamespaceConfig
      @@configs[namespace] ||= begin
        filename = "#{namespace.underscore}.yml"
        filepath = find_in_search_paths(filename)
        if filepath.nil?
          Log.notice do
            "No configuration found for #{namespace} (#{filename}), " \
            "looked at #{Config.search_paths.map(&.expand).join(", ")}."
          end
          NamespaceConfig.new
        else
          Log.notice { "Loading #{filepath}" }
          any = YAML.parse(File.read(filepath))
          add_mappings(any)
          NamespaceConfig.new(any, filepath.dirname)
        end
      end
    end

    def self.for(namespace : String) : NamespaceConfig
      load(namespace)
    end

    private def self.find_in_search_paths(file : String) : Path?
      @@search_paths.each do |path|
        path = File.join(path, file)
        return Path.new(path).expand if File.exists?(path)
      end
      nil
    end

    private def self.add_mappings(any : YAML::Any)
      mappings = any["mappings"]?
      return if mappings.nil?

      hash = mappings.as_h?
      raise Error.new("Expecting a hash on mappings entry, got #{any.raw.class.name}") if hash.nil?

      hash.each do |key, value|
        str_key = key.as_s?
        str_value = value.as_s?
        raise Error.new("Mappings must be strings") if str_key.nil? || str_value.nil?
        raise Error.new("Mapping for #{str_key} already exists.") if @@mappings.has_key?(str_key)

        @@mappings[str_key] = str_value
      end
    end
  end
end
