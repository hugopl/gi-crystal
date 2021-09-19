require "file_utils"

require "./file_gen"
require "./wrapper_util"
require "./object_gen"
require "./struct_gen"
require "./interface_gen"
require "./lib_gen"

module Generator
  class ModuleGen < FileGen
    include WrapperUtil

    @objects : Array(ObjectGen)
    @structs : Array(StructGen)
    @interfaces : Array(InterfaceGen)

    @@loaded_modules = Hash(String, ModuleGen).new

    def self.load(namespace : String, version : String? = nil) : ModuleGen
      @@loaded_modules[namespace] ||= begin
        ModuleGen.new(namespace, version).tap do |gen|
          raise Error.new("A module with a different version was already loaded") if version && version != gen.version
        end
      end
    end

    protected def initialize(namespace : String, version : String?)
      @namespace = GObjectIntrospection::Repository.require(namespace, version)
      with_log_scope(&->config) # load binding config

      @objects = @namespace.objects.map { |info| ObjectGen.new(info) }.reject(&.skip?)
      @structs = @namespace.structs.map { |info| StructGen.new(info) }.reject(&.skip?)
      @interfaces = @namespace.interfaces.map { |info| InterfaceGen.new(info) }.reject(&.skip?)
      @lib = LibGen.new(@namespace)
    end

    delegate version, to: @namespace

    def scope : String
      namespace.name
    end

    def filename : String
      "#{@namespace.name.underscore}.cr"
    end

    delegate constants, to: @namespace
    delegate enums, to: @namespace
    delegate flags, to: @namespace

    def generate
      super

      copy_extra_includes
      @lib.generate
      @objects.each(&.generate)
      @structs.each(&.generate)
      @interfaces.each(&.generate)
    end

    # Files of all generated wrappers
    private def wrapper_files : Array(String)
      requires = [] of String
      {% for collection in %w(@objects @structs @interfaces) %}
      {{ collection.id }}.each do |gen|
        requires << gen.filename unless gen.skip?
      end
      {% end %}
      requires.sort!
    end

    # Copy include files added by binding YAML configuration into `outputdir/module_dir/includes/` directory.
    private def copy_extra_includes
      includes = config.includes
      return if includes.empty?

      Dir.mkdir_p(File.join(output_dir, module_dir, "includes"))
      config.includes.each do |file|
        dest = File.join(output_dir, module_dir, "includes", file.basename)
        Log.debug { "Copying '#{file}' to '#{dest}'" }
        File.copy(file, dest)
      end
    rescue e : File::NotFoundError
      raise Error.new(e.message)
    end

    private def immediate_dependencies : Array(ModuleGen)
      @namespace.immediate_dependencies.map do |dep|
        namespace, version = dep.split('-', 2)
        ModuleGen.load(namespace, version)
      end
    end

    def dependencies : Array(ModuleGen)
      @namespace.dependencies.map do |dep|
        namespace, version = dep.split('-', 2)
        ModuleGen.load(namespace, version)
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
  end
end
