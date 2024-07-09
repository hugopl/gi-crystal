module Generator
  abstract class CallableGen < Generator
    def method_gi_annotations : String
      args = callable.args
      String.build do |io|
        io << "# "
        callable.to_s(io) << ": (" << callable.flags.to_s << ")\n"
        args_gi_annotations(io, args)

        io << "# Returns: (transfer " << callable.caller_owns.to_s.downcase
        return_type = callable.return_type
        io << ") (filename" if return_type.tag.filename?
        io << ") (nullable" if callable.may_return_null?
        io << ") "
        type_info_gi_annotations(io, callable.return_type, args)
        io << LF
      end
    end
  end
end
