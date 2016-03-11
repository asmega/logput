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
      # @param [Class] logger
      # @return [Boolean]
      def self.handles?(logger)
        raise NotImplementedError
      end

      # Placeholder for path method to be overridden when subclassed
      # @return [String] path
      def path
        raise NotImplementedError
      end
    end
  end
end
