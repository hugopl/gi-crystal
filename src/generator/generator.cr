require "ecr"
require "log"

require "../gobject_introspection"
require "./helpers"
require "./doc_helper"

module Generator
  include GObjectIntrospection

  LF  = "\n"
  Log = ::Log.for("generator")

  abstract class Generator
    include Helpers
    include DocHelper

    @@log_scope = Deque(String).new
    @@output_dir = "./"

    getter config : BindingConfig
    getter namespace : Namespace

    def initialize(@namespace)
      @config = BindingConfig.for(@namespace.name, @namespace.version)
    end

    def self.push_log_scope(context : String)
      @@log_scope.push(context)
      # For some reason this call is *really* slow, probably a bug.
      # So the log formatter uses @@log_scope directly.
      # Log.context.set(scope: context)
    end

    def self.pop_log_scope
      @@log_scope.pop
    end

    def self.log_scope
      @@log_scope.last?
    end

    def self.output_dir=(value : String)
      @@output_dir = value
    end

    def self.output_dir
      @@output_dir
    end

    def output_dir
      Generator.output_dir
    end

    def module_dir(namespace : Namespace = @namespace)
      "#{namespace.name.underscore}-#{namespace.version}"
    end

    def scope : String
      self.class.name
    end

    def with_log_scope(scope_name = scope, &)
      Generator.push_log_scope(scope_name)
      yield
    ensure
      Generator.pop_log_scope
    end

    macro inherited
      {% unless @type.abstract? %}
      def generate(io : IO)
        with_log_scope do
          # Generator::ModuleGen class needs `module.ecr` and so on.
          ECR.embed({{ "ecr/" + @type.name[11..-4].underscore.stringify + ".ecr" }}, io)
        end
      end
      {% end %}
    end

    macro render(filename, object = object)
      begin
        {% if object.id != "object" %}
        object = {{ object.id }}
        {% end %}
        ECR.embed({{ filename }}, io)
      end
    end
  end
end
