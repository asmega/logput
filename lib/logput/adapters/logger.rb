# Logput
module Logput
  # Logging Adapters
  module Adapters
    # Logger Adapter
    class Logger < Base
      register :logger

      # @param [Class] logger
      # @return [Boolean]
      def self.handles?(logger)
        return false unless logger
        logger.is_a? ::Logger
      end

      # @return [String] path
      def path
        @logger.instance_variable_get(:@logdev).filename
      end
    end
  end
end
