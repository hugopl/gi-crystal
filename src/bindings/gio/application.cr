module Gio
  class Application
    # Invoke `Application#run` with the process argc/argv.
    #
    # If no commandline handling is required you can invoke `Application#run(nil)`
    def run : Int32
      LibGio.g_application_run(self, ARGC_UNSAFE, ARGV_UNSAFE)
    end

    def run(argv : Enumerable(::String)?) : Int32
      argv = [PROGRAM_NAME].concat(argv) if argv
      # call generated method
      previous_def(argv)
    end
  end
end
