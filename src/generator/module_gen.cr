require "file_utils"

require "./file_gen"
require "./wrapper_util"
require "./object_gen"
require "./heap_struct_gen"
require "./heap_wrapper_struct_gen"
require "./stack_struct_gen"
require "./interface_gen"
require "./lib_gen"

module Generator
  class ModuleGen < FileGen
    include WrapperUtil
    include MethodHolder

    @objects : Array(ObjectGen)
    @structs : Array(StructGen)
    @interfaces : Array(InterfaceGen)
    getter? already_generated = false

    @@loaded_modules = Hash(String, ModuleGen).new

    def self.load(info : BindingConfig) : ModuleGen
      @@loaded_modules[info.namespace] ||= ModuleGen.new(info)
    end

    protected def initialize(@config : BindingConfig)
      @namespace = GObjectIntrospection::Repository.default.require(@config.namespace, @config.version)

      @objects = @namespace.objects.compact_map do |info|
        ObjectGen.new(info) if should_generate_code?(info)
      end
      @structs = @namespace.structs.compact_map do |info|
        StructGen.new(info) if should_generate_code?(info)
      end
      @interfaces = @namespace.interfaces.compact_map do |info|
        InterfaceGen.new(info) if should_generate_code?(info)
      end
      @lib = LibGen.new(@namespace)
    end

    private def should_generate_code?(info : RegisteredTypeInfo) : Bool
      type_config = config.type_config(info.name)
      !(type_config.handmade? || type_config.ignore?)
    end

    private def should_generate_code?(info : StructInfo) : Bool
      return false if info.g_type_struct? || info.g_error?

      type_config = config.type_config(info.name)
      !(type_config.handmade? || type_config.ignore?)
    end

    delegate version, to: @namespace

    def object
      @namespace
    end

    def scope : String
      namespace.name
    end

    def filename : String
      "#{@namespace.name.underscore}.cr"
    end

    delegate constants, to: @namespace
    delegate enums, to: @namespace
    delegate flags, to: @namespace

    def each_callback(&)
      @namespace.callbacks.each do |callback|
        yield(callback) unless config.type_config(callback.name).ignore?
      end
    end

    def generate
      return if already_generated?

      @already_generated = true
      super

      @lib.generate
      @objects.each(&.generate)
      @structs.each(&.generate)
      @interfaces.each(&.generate)

      immediate_dependencies.each(&.generate)
    end

    # Files of all generated wrappers
    private def wrapper_files : Array(String)
      requires = [] of String
      {% for collection in %w(@objects @structs @interfaces) %}
      {{ collection.id }}.each do |gen|
        requires << gen.filename
      end
      {% end %}
      requires.sort!
    end

    private def immediate_dependencies : Array(ModuleGen)
      @namespace.immediate_dependencies.map do |dep|
        namespace, version = dep.split('-', 2)
        ModuleGen.load(BindingConfig.for(namespace, version))
      end
    end

    private def gerror_to_crystal_implementation : String
      return "" if enums.none?(&.error_domain)

      String.build do |s|
        s << "error_domain = error.value.domain\n" \
             "error_code = error.value.code\n\n"

        enums.each do |enum_|
          domain = enum_.error_domain
          next if domain.nil?

          error_domain_type = to_type_name(enum_.name)

          s << "if error_domain == LibGLib.g_quark_try_string(\"" << domain << "\")\n"
          enum_.values.each do |value|
            s << "return " << error_domain_type << "::" << to_type_name(value.name) <<
              ".new(error, transfer) if error_code == " << value.value << LF
          end
          s << "end\n\n"
        end
      end
    end

    # Crystal auto-generate All and None flag entries, so we check if the C flag also defines that, if so
    # we check if the value is corretc, otherwise we warn ⚠️
    private def check_about_invalid_flag_all_value(flag : EnumInfo, int_value : Int64) : Nil
      all_value = 0_i64
      flag.values.each { |v| all_value |= v.value }
      all_value
      if int_value != all_value
        flag_name = to_type_name(flag.name)
        Log.warn do
          "#{flag_name}::All (0x#{int_value.to_s(16)}) doesn't have all possible bits set (0x#{all_value.to_s(16)})."
        end
      end
    end

    private def skip_flag_value?(flag : EnumInfo, value : ValueInfo) : Bool
      int_value = value.value
      return true if int_value.zero? && flag.values.size != 1 && value.name == "none"

      if value.name == "all"
        check_about_invalid_flag_all_value(flag, int_value)
        return true
      end
      false
    end

    private def empty_flag?(flag : EnumInfo)
      values = flag.values
      return false if values.size != 1

      values.first.value.zero?
    end

    private def declare_error? : Bool
      enums.any?(&.error_domain)
    end
  end
end
