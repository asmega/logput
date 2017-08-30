# Logput
module Logput
  # Logging Adapters
  module Adapters
    # Base class from which all adapters inherit
    class Base
      # Initialize
      def initialize(logger)
        @logger = logger
      end

      # Registers a new adapter
      #
      # @param [Symbol] adapter The name of the adapter
      def self.register(adapter)
        raise "Already Registered :#{adapter}" if Logput::Adapters.registered_adapters[adapter]
        Logput::Adapters.registered_adapters[adapter] = self
      end

      # Placeholder for handles? method to be overridden when subclassed
      # @param [Class] _logger
      # @return [Boolean]
      def self.handles?(_logger)
        raise NotImplementedError
      end

      # Placeholder for path method to be overridden when subclassed
      # @return [String] path
      def path
        raise NotImplementedError
      end

      # Enable overriding of the path with an environment variable
      # @return [String] path
      def path_override
        return unless directory && filename

        "#{directory}/#{filename}.log"
      end

      private

      def filename
        @filename ||= ENV['LOG_NAME'] || ENV['RAILS_ENV'] || ENV['RACK_ENV']
      end

      def directory
        @directory ||= ENV['LOG_LOCATION_DIR']
      end
    end
  end
end
