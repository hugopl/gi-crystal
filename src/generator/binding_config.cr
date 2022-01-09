require "yaml"

module Generator
  class BindingConfig
    getter namespace : String
    getter version : String
    getter includes : Set(Path)
    getter handmade : Set(String)
    getter ignore : Set(String)

    getter base_path : Path

    class_getter loaded_configs = Hash(String, BindingConfig).new

    # Constructs a binding config object from a yaml file
    def initialize(file : Path)
      file = file.expand
      data = YAML.parse(File.read(file))
      @base_path = file.parent
      @namespace = data["namespace"].as_s? || raise Error.new("namespace must be a string.")
      @version = data["version"].as_s? || raise Error.new("version must be a string.")

      @includes = Set(Path).new
      read_list(data, "include").each do |i|
        @includes << @base_path.join(i)
      end
      @handmade = read_list(data, "handmade")
      @ignore = read_list(data, "ignore")
    end

    # Constructs an empty binding config
    def initialize(@namespace, @version)
      @includes = Set(Path).new
      @handmade = @ignore = Set(String).new
      @base_path = Path.new(".")
    end

    private def read_list(data : YAML::Any, key : String) : Nil
      value = data[key]?
      return Set(String).new if value.nil?
      raise Error.new("'#{key}' value must be a list of strings.") unless value.as_a?

      value.as_a.each do |item|
        value = item.to_s
        yield(value)
      end
    end

    private def read_list(data : YAML::Any, key : String) : Set(String)
      list = Set(String).new
      read_list(data, key) do |value|
        raise Error.new("duplicated item '#{value}' on '#{key}'") if list.includes?(value)

        list << value
      end
      list
    end

    def ignore?(name : String) : Bool
      @ignore.includes?(name)
    end

    def handmade?(name : String) : Bool
      @handmade.includes?(name)
    end

    def self.handmade?(type_info : TypeInfo) : Bool
      return false unless type_info.tag.interface?

      iface = type_info.interface
      return false if iface.nil?

      namespace = iface.namespace
      for(namespace.name, namespace.version).handmade?(iface.name)
    end

    def self.load(files : Enumerable(String))
      files.each { |file| load(file) }
    end

    def self.load(file : String)
      conf = BindingConfig.new(Path.new(file))
      namespace = conf.namespace
      raise Error.new("binding config already loaded for #{namespace} namespace.") if @@loaded_configs.has_key?(namespace)
      @@loaded_configs[namespace] = conf
    rescue e : Error
      raise Error.new("Error loading #{file}: #{e.message}")
    rescue e : KeyError
      raise Error.new("Error loading #{file}: #{e.message}")
    end

    def self.for(namespace : Namespace) : BindingConfig
      for(namespace.name, namespace.version)
    end

    def self.for(namespace : String, version : String) : BindingConfig
      conf = @@loaded_configs[namespace]?
      if conf.nil?
        Log.info { "No binding config found for #{namespace}-#{version}." }
        conf = BindingConfig.new(namespace, version)
        @@loaded_configs[namespace] = conf
        return conf
      end

      if conf.version != version
        raise Error.new("Binding configuration for version #{conf.namespace}-#{conf.version} was found, " \
                        "but the binding requires #{namespace}-#{version}.")
      end
      conf
    end
  end
end
