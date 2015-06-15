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
      @path_to_log_file ||= default_path_to_log_file(env)

      raise 'Log file does not exist' unless File.exists? @path_to_log_file

      if env['PATH_INFO'] == '/logput'
        out = `tail -n #{@lines_to_read} #{@path_to_log_file}`
        [200, {"Content-Type" => "text/html"}, ["<pre>", out, "</pre>"]]
      else
        @app.call(env)
      end
    end

    private

    def default_path_to_log_file(env)
      raise Exception, 'Must specify path to log file' unless defined? Rails

      if Rails.version >= "4.0.0"
        logger(env).instance_variable_get(:@logdev).instance_variable_get(:@dev).path
      else
        logger(env).instance_variable_get(:@logger).instance_variable_get(:@log_dest).path
      end
    end

    def logger(env)
      env['action_dispatch.logger']
    end
  end
end
