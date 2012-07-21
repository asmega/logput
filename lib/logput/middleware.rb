module Logput
  class Middleware
    def initialize(app, options = {})
      @app = app
      @path_to_log_file = options[:path_to_log_file] || default_path_to_log_file
      @lines_to_read = options[:lines_to_read] || 500
    end

    def call(env)
      if env['PATH_INFO'] == '/logput'
        if File.exists? @path_to_log_file
          out = `tail -n #{@lines_to_read} #{@path_to_log_file}`

          [200, {"Content-Type" => "text/html"}, out]
        else
          [404, {"Content-Type" => "text/html"}, "Log file not found."]
        end
      else
        @app.call(env)
      end
    end

    private

    def default_path_to_log_file
      if defined? Rails
        './log/development.log'
      else
        raise Exception, 'Must specify path to log file'
      end
    end
  end
end
