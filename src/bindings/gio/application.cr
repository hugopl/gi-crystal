module Gio
  class Application
    # Invoke `Application#run` with the process argc/argv.
    #
    # If no commandline handling is required you can invoke `Application#run(nil)`
    def run : Int32
      # Like the generated `run(argv)`, this must run in a isolated execution context, see
      # `blocks` on BINDING_YML.md.
      GICrystal.run_blocking("g_application_run") do
        LibGio.g_application_run(self, ARGC_UNSAFE, ARGV_UNSAFE)
      end
    end

    def run(argv : Enumerable(::String)?) : Int32
      argv = [PROGRAM_NAME].concat(argv) if argv
      # call generated method
      previous_def(argv)
    end
  end
end
