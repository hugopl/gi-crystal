require "file_utils"

require "./obj_wrapper_generator"
require "./method_wrapper_generator"
require "./struct_wrapper_generator"
require "./interface_wrapper_generator"
require "./lib_decl_generator"

module Generator
  class ModuleWrapperGenerator < Base
    include WrapperUtil

    getter namespace : Namespace

    @objects : Array(ObjWrapperGenerator)
    @structs : Array(StructWrapperGenerator)
    @interfaces : Array(InterfaceWrapperGenerator)
    @already_generated = false

    @@loaded_modules = Hash(String, ModuleWrapperGenerator).new

    def self.load(namespace : String, version : String? = nil) : ModuleWrapperGenerator
      @@loaded_modules[namespace] ||= begin
        ModuleWrapperGenerator.new(namespace, version).tap do |gen|
          raise Error.new("A module with a different version was already loaded") if version && version != gen.version
        end
      end
    end

    protected def initialize(namespace : String, version : String?)
      @namespace = GObjectIntrospection::Repository.require(namespace, version)
      Config.load(@namespace.name)

      @objects = @namespace.objects.map { |info| ObjWrapperGenerator.new(@namespace, info) }
      @structs = @namespace.structs.map { |info| StructWrapperGenerator.new(@namespace, info) }
      @interfaces = @namespace.interfaces.map { |info| InterfaceWrapperGenerator.new(@namespace, info) }
      @lib = LibDeclGenerator.new(@namespace)
    end

    delegate version, to: @namespace

    def filename : String?
      "#{@namespace.name.underscore}.cr"
    end

    def subject : String
      @namespace.name
    end

    def module_dir
      "#{@namespace.name.underscore}-#{@namespace.version}"
    end

    def generate(output_dir : String)
      return if @already_generated

      output_dir = File.join(output_dir, module_dir)
      FileUtils.mkdir_p(output_dir)
      super(output_dir)

      @lib.generate(output_dir)
      @objects.each(&.generate(output_dir))
      @structs.each(&.generate(output_dir))
      @interfaces.each(&.generate(output_dir))
      copy_extra_includes(output_dir)
      @already_generated = true
    end

    def do_generate(io : IO)
      Log.notice { "Generating #{@namespace.name} bindings at '#{output_dir}'." }
      generate_require_calls(io)

      io << "# Module functions\n"
      io << "module " << to_type_name(@namespace.name) << LF
      generate_constants(io)
      generate_enums(io)
      generate_flags(io)
      MethodWrapperGenerator.generate(io, @namespace.functions)
      io << "extend self\n"
      io << "end\n"

      generate_extra_includes(io)
    end

    private def generate_require_calls(io : IO)
      generate_dependencies(io)

      io << "# C lib declaration\nrequire \"./" << @lib.filename << "\"\n\n"
      io << "# Wrappers\n"
      (@objects + @structs).reject(&.skip?).compact_map(&.filename).sort!.each do |filename|
        io << "require \"./" << filename << "\"\n"
      end
    end

    private def generate_extra_includes(io : IO)
      extra_includes = Config.for(@namespace.name).includes
      return if extra_includes.empty?

      io << "\n# Extra includes\n"
      extra_includes.each do |file|
        io << "require \"./includes/" << file.basename << "\"\n"
      end
      io << LF
    end

    private def copy_extra_includes(output_dir : String)
      includes = Config.for(@namespace.name).includes
      return if includes.empty?

      Dir.mkdir_p(File.join(output_dir, "includes"))
      Config.for(@namespace.name).includes.each do |file|
        dest = File.join(output_dir, "includes", file.basename)
        Log.info { "Copying '#{file}' to '#{dest}'" }
        File.copy(file, dest)
      end
    rescue e : File::NotFoundError
      raise Error.new(e.message)
    end

    private def generate_dependencies(io : IO)
      io << "# Dependencies\n"
      immediate_dependencies.each do |dep|
        io << "require \"../" << dep.module_dir << "/" << dep.filename << "\"\n"
      end
      io << LF
    end

    private def immediate_dependencies : Array(ModuleWrapperGenerator)
      @namespace.immediate_dependencies.map do |dep|
        namespace, version = dep.split('-', 2)
        ModuleWrapperGenerator.load(namespace, version)
      end
    end

    def dependencies : Array(ModuleWrapperGenerator)
      @namespace.dependencies.map do |dep|
        namespace, version = dep.split('-', 2)
        ModuleWrapperGenerator.load(namespace, version)
      end
    end

    private def generate_constants(io : IO)
      io << "# Constants\n"
      @namespace.constants.each do |constant|
        io << constant.name << " = " << constant.literal << LF
      end
    end

    private def generate_enums(io : IO)
      return if @namespace.enums.empty?

      io << "# Enums\n"
      @namespace.enums.each do |info|
        io << "enum " << to_type_name(info.name) << " : " << to_crystal_type(info.storage_type) << LF
        info.values.each do |value|
          next if value.deprecated?
          io << to_type_name(value.name) << " = " << value.value << LF
        end
        io << "end\n"
      end
    end

    private def generate_flags(io : IO)
      return if @namespace.flags.empty?

      io << "# Flags\n"
      @namespace.flags.each do |flag|
        flag_name = to_type_name(flag.name)

        if empty_flag?(flag)
          io << flag_name << " = " << 0 << "\n\n"
          next
        end

        io << "@[Flags]\n"
        io << "enum " << flag_name << " : " << to_crystal_type(flag.storage_type) << LF

        # Crystal auto-generate All and None flag entries, so we check if the C flag also defines that, if so
        # we check if the value is corretc, otherwise we warn ⚠️
        all_value = 0_u64
        flag.values.each { |v| all_value |= v.value }

        flag.values.each do |value|
          name = to_type_name(value.name)
          value = value.value
          next if name == "None" && value.zero? && flag.values.size != 1
          if name == "All"
            if value != all_value
              Log.warn { "#{flag_name}::All (0x#{value.to_s(16)}) doesn't have all possible bits set " \
                         "(0x#{all_value.to_s(16)})." }
            end
            next
          end

          io << name << " = " << value << LF
        end
        io << "end\n\n"
      end
    end

    def empty_flag?(flag : EnumInfo)
      values = flag.values
      return false if values.size != 1

      values.first.value.zero?
    end
  end
end
