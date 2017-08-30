require 'spec_helper'

describe Logput::Adapters::TaggedLogging do
  describe '.handles?' do
    it 'returns true when passed an ActiveSupport::TaggedLogging instance' do
      expect(described_class.handles?(::ActiveSupport::TaggedLogging.new)).to eq(true)
    end

    it 'returns false when passed anything else' do
      expect(described_class.handles?(::Logger.new)).to eq(false)
      expect(described_class.handles?(:foo)).to eq(false)
    end
  end

  describe '#path' do
    let(:path) { './spec/support/test.log' }
    let(:logger) { ::ActiveSupport::TaggedLogging.new }
    let(:logvar) { double }
    let(:logdev) { double(:filename => path) }
    let(:log_dest) { double(:path => path) }

    before :each do
      allow(logger).to receive(:instance_variable_get).with(:@logger).and_return(logvar)
      allow(logvar).to receive(:instance_variable_get).with(:@log_dest).and_return(log_dest)
    end

    subject { described_class.new(logger) }

    it 'returns the correct path' do
      expect(subject.path).to eq(path)
    end

    context 'when environment variable overrides are present' do
      after :each do
        ENV['LOG_NAME'] = nil
        ENV['LOG_LOCATION_DIR'] = nil
      end

      it 'returns the overridden path' do
        ENV['LOG_NAME'] = 'development'
        ENV['LOG_LOCATION_DIR'] = 'logs'
        expect(subject.path).to eq('logs/development.log')
      end
    end
  end
end
