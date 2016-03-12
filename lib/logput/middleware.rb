# Logput
module Logput
  # Middleware
  class Middleware
    def initialize(app, options = {})
      @app = app
      @path_to_log_file = options[:path_to_log_file]
      @lines_to_read = options[:lines_to_read] || 500
    end

    # Call
    def call(env)
      @env = env
      @path_to_log_file ||= default_path_to_log_file

      ensure_log_file_exists!

      if is_logput?
        generate_output!
      else
        @app.call(@env)
      end
    end

    private

    def ensure_log_file_exists!
      raise 'Log file does not exist' unless File.exist? @path_to_log_file
    end

    def is_logput?
      @env['PATH_INFO'] == '/logput'
    end

    def generate_output!
      out = `tail -n #{@lines_to_read} #{@path_to_log_file}`
      [200, {"Content-Type" => "text/html"}, ["<pre>", out, "</pre>"]]
    end

    def default_path_to_log_file
      raise Exception, 'Must specify path to Rails log file' unless defined? Rails
      path
    end

    def logger
      @env['action_dispatch.logger']
    end

    def path
      logger_adapter.path
    end

    def logger_adapter
      @logger_adapter ||= Logput::Adapters.obtain(logger)
    end
  end
end
