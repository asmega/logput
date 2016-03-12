# Logput
module Logput
  # Logging Adapters
  module Adapters
    # @return [Hash] Currently registered adapters
    def self.registered_adapters
      @registered_adapters ||= {}
    end

    # Find a registered adapter
    # @return [Adapter] An instance of the adapter, or raise an exception
    def self.obtain(logger)
      registered_adapters.each do |_, adapter|
        return adapter.new(logger) if adapter.handles?(logger)
      end
      raise "#{logger} is not supported."
    end

    require 'logput/adapters/base'
    require 'logput/adapters/logger'
    require 'logput/adapters/tagged_logging'
  end
end
