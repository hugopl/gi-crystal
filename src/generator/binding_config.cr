require "yaml"

require "./error"
require "./generator"

module Generator
  enum BindingStrategy
    Auto
    # Bind the type as a Crystal struct
    StackStruct
    # Bind the type as a Crystal class with the lib struct as attribute.
    HeapStruct
    # Bind the type as a Crystal class with a pointer to the object.
    HeapWrapperStruct
  end

  class TypeConfig
    include YAML::Serializable
    include YAML::Serializable::Strict

    def initialize
    end

    getter binding_strategy : BindingStrategy = BindingStrategy::Auto
    @ignore_methods : Set(String)?
    @ignore_fields : Set(String)?
    getter? handmade = false
    getter? ignore = false

    {% for attr in %w(ignore_method ignore_field) %}
    def {{ attr.id }}?(name : String) : Bool
      {{ attr.id }} = @{{ attr.id }}s
      return false if {{ attr.id }}.nil?

      {{ attr.id }}.includes?(name)
    end
    {% end %}
  end

  class BindingConfig
    include YAML::Serializable
    include YAML::Serializable::Strict

    getter namespace : String
    getter version : String
    getter require_before = Set(Path).new
    getter require_after = Set(Path).new
    @types = Hash(String, TypeConfig).new
    getter lib_ignore = Set(String).new
    getter execute_callback = Set(String).new
    getter ignore_constants = Set(String).new

    class_getter loaded_configs = Hash(String, BindingConfig).new

    @@empty_type_config = TypeConfig.new

    # Constructs an empty binding config
    def initialize(@namespace, @version)
    end

    def adjust_paths(path : Path)
      {% for ivar in %w(@require_before @require_after) %}
        tmp = {{ ivar.id }}
        {{ ivar.id }} = Set(Path).new
        tmp.each do |p|
          {{ ivar.id }} << path.join(p)
        end
      {% end %}
    end

    def type_config(type : String) : TypeConfig
      @types[type]? || @@empty_type_config
    end

    def lib_ignore?(symbol : String) : Bool
      @lib_ignore.includes?(symbol)
    end

    def self.load(file : String)
      load(Path.new(file))
    end

    def self.load(file : Path)
      File.open(file) do |fp|
        conf = from_yaml(fp)
        conf.adjust_paths(file.parent)
        namespace = conf.namespace
        raise Error.new("Binding config already loaded for #{namespace} namespace.") if @@loaded_configs.has_key?(namespace)
        @@loaded_configs[namespace] = conf
      end
    rescue e : YAML::ParseException
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
