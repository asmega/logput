# Logput
module Logput
  # Logging Adapters
  module Adapters
    # Active Support Tagged Logging Adapter
    class TaggedLogging < Base
      register :tagged_logging

      # @param [Class] logger
      # @return [Boolean]
      def self.handles?(logger)
        return false unless logger
        logger.is_a? ::ActiveSupport::TaggedLogging
      end

      # @return [String] path
      def path
        @logger.instance_variable_get(:@logger).instance_variable_get(:@log_dest).path
      end
    end
  end
end
