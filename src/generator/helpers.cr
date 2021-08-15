module Generator::Helpers
  KEYWORDS = {"abstract", "alias", "begin", "def", "end", "in", "module", "next", "out", "self"}

  def to_get_type_function(struct_info : StructInfo)
    "#{struct_info.namespace.name.underscore}_#{struct_info.name.underscore}_get_type"
  end

  def to_lib_namespace(namespace : Namespace)
    name = namespace.name
    "Lib#{name[0].upcase}#{name[1..-1]}"
  end

  def to_identifier(name : String) : String
    KEYWORDS.includes?(name) ? "_#{name}" : name
  end

  def to_type_name(name : String) : String
    name = name.camelcase
    if name.starts_with?(/[_0-9]/)
      "G#{name}"
    elsif name[0].lowercase?
      "#{name[0].upcase}#{name[1..-1]}"
    else
      name
    end
  end

  def to_method_name(name : String) : String
    name.tr("-", "_")
  end

  def to_lib_type(tag : TypeTag) : String
    case tag
    when .void?             then "Void"
    when .boolean?          then "LibC::Int"
    when .int8?             then "Int8"
    when .u_int8?           then "UInt8"
    when .int16?            then "Int16"
    when .u_int16?          then "UInt16"
    when .int32?            then "Int32"
    when .u_int32?          then "UInt32"
    when .int64?            then "Int64"
    when .u_int64?          then "UInt64"
    when .float?            then "Float32"
    when .double?           then "Float64"
    when .utf8?, .filename? then "LibC::Char"
    when .gtype?            then "UInt64"
    when .g_list?           then "LibGLib::List"
    when .gs_list?          then "LibGLib::SList"
    when .g_hash?           then "Void"
    when .unichar?          then "UInt32"
    when .error?            then "LibGLib::Error"
    else
      raise Error.new("Unknown lib representation for #{tag}")
    end
  end

  def to_lib_type(type : TypeInfo, include_namespace : Bool = true) : String
    tag = type.tag

    is_pointer = type.pointer?
    value = if tag.interface?
              iface = type.interface
              # Consider all interfaces a Void* makes a lot of things easier to the generator that doesn't need to write
              # zillion of pointer casts
              return "Pointer(Void)" if iface.nil?

              case iface
              when CallbackInfo
                name = to_type_name(iface.name)
                if iface.namespace.has_declared_callback?(name)
                  include_namespace ? "#{to_lib_namespace(iface.namespace)}::#{name}" : name
                else
                  "-> Void"
                end
              when EnumInfo
                to_lib_type(iface.storage_type)
              when UnionInfo
                to_lib_type(iface, include_namespace)
              when ObjectInfo, StructInfo, InterfaceInfo
                is_pointer = true
                "Void"
              else
                raise Error.new("Unknown lib representation for #{iface.class.name}.")
              end
            elsif tag.array?
              array_type_name = to_lib_type(type.param_type, include_namespace)
              len = type.array_fixed_size
              len > 0 ? "#{array_type_name}[#{len}]" : array_type_name
            else
              to_lib_type(tag)
            end
    is_pointer ? "Pointer(#{value})" : value
  end

  def to_lib_type(info : BaseInfo, include_namespace : Bool = true) : String
    return to_lib_type(info, include_namespace) if info.as?(TypeInfo)

    case info
    when FunctionInfo
      name = info.symbol
      include_namespace ? "#{to_lib_namespace(info.namespace)}.#{name}" : name
    else
      name = to_type_name(info.name)
      include_namespace ? "#{to_lib_namespace(info.namespace)}::#{name}" : name
    end
  end

  def convert_to_lib(var : String, type : TypeInfo, _transfer : Transfer) : String
    if type.tag.interface?
      "#{var}.to_unsafe"
    else
      var
    end
  end

  def to_crystal_arg_decl(name : String)
    if KEYWORDS.includes?(name)
      "#{name} _#{name}"
    else
      name
    end
  end

  def to_crystal_type(tag : TypeTag) : String
    case tag
    when .void?             then "Nil"
    when .boolean?          then "Bool"
    when .int8?             then "Int8"
    when .u_int8?           then "UInt8"
    when .int16?            then "Int16"
    when .u_int16?          then "UInt16"
    when .int32?            then "Int32"
    when .u_int32?          then "UInt32"
    when .int64?            then "Int64"
    when .u_int64?          then "UInt64"
    when .float?            then "Float32"
    when .double?           then "Float64"
    when .utf8?, .filename? then "::String"
    when .gtype?            then "UInt64"
    when .g_list?           then "GLib::List"
    when .gs_list?          then "GLib::SList"
    when .g_hash?           then "Void"
    when .unichar?          then "UInt32"
    when .error?            then "GLib::Error"
    else
      raise Error.new("Unknown Crystal representation for #{tag}")
    end
  end

  def to_crystal_type(type : TypeInfo, include_namespace : Bool = true) : String
    tag = type.tag
    case tag
    when .interface?
      iface = type.interface
      return "Pointer(Void)" if iface.nil?
      to_crystal_type(iface, include_namespace)
    when .array?
      t = to_crystal_type(type.param_type, include_namespace)
      "Enumerable(#{t})"
    when tag.utf8?, .filename?, .g_list?, .gs_list?
      to_crystal_type(tag)
    else
      tag_str = to_crystal_type(tag)
      if type.pointer? && !tag.utf8? && !tag.g_list? && !tag.gs_list?
        "Pointer(#{tag_str})"
      else
        tag_str
      end
    end
  end

  def to_crystal_type(info : BaseInfo, include_namespace : Bool = true) : String
    if info.as?(TypeInfo)
      return to_crystal_type(info, include_namespace)
    elsif info.as?(CallableInfo)
      return "Pointer(Void)" # TODO
    end

    name = to_type_name(info.name)
    name = "#{to_type_name(info.namespace.name)}::#{name}" if include_namespace
    name
  end

  # @var: Variable name in lib format.
  # @type: Type info
  # @transfer: Transfer mode
  def convert_to_crystal(var : String, type : TypeInfo, transfer : GICrystal::Transfer) : String
    tag = type.tag
    case tag
    when .boolean?
      return "GICrystal.to_bool(#{var})"
    when .int8?, .u_int8?, .int16?, .u_int16?, .int32?, .u_int32?, .int64?, .u_int64?, .float?, .double?, .unichar?, .gtype?
      return var
    when .utf8?, .filename?
      if transfer.full?
        "GICrystal.transfer_full(#{var})"
      else
        "::String.new(#{var})"
      end
    when .interface?
      iface = type.interface.not_nil!
      convert_to_crystal(var, iface, transfer)
    when .void?
      type.pointer? ? "Pointer(Void)" : "Void"
    when .g_list?
      param_type = to_crystal_type(type.param_type)
      "#{to_crystal_type(tag)}(#{param_type}).new(#{var}, GICrystal::Transfer::#{transfer})"
    when .gs_list?
      param_type = to_crystal_type(type.param_type)
      "#{to_crystal_type(tag)}(#{param_type}).new(#{var}, GICrystal::Transfer::#{transfer})"
    when .array?
      if type.array_zero_terminated?
        "GICrystal.transfer_null_ended_array(#{var}, GICrystal::Transfer::#{transfer})"
      else
        Log.warn { "Unknown conversion to crystal for non null terminated array" }
        var
      end
    else
      Log.warn { "Unknown conversion to crystal for #{tag}" }
      var
    end
  end

  def convert_to_crystal(var : String, info : BaseInfo, transfer : GICrystal::Transfer) : String
    case info
    when TypeInfo
      convert_to_crystal(var, info, transfer)
    when EnumInfo
      "#{to_crystal_type(info, true)}.from_value(#{var})"
    else
      crystal_type = to_crystal_type(info, true)
      crystal_type = "#{crystal_type}__Impl" if info.is_a?(InterfaceInfo)
      "#{crystal_type}.new(#{var}, GICrystal::Transfer::#{transfer})"
    end
  end
end
