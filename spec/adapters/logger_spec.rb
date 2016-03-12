require 'spec_helper'

describe Logput::Adapters::Logger do
  describe '.handles?' do
    it 'returns true when passed a Logger instance' do
      expect(described_class.handles?(::Logger.new)).to eq(true)
    end

    it 'returns false when passed anything else' do
      expect(described_class.handles?(::ActiveSupport::TaggedLogging.new)).to eq(false)
      expect(described_class.handles?(:foo)).to eq(false)
    end
  end

  describe '#path' do
    let(:path) { './spec/support/test.log' }
    let(:logger) { ::Logger.new }
    let(:logdev) { double(:filename => path) }

    before :each do
      allow(logger).to receive(:instance_variable_get).with(:@logdev).and_return(logdev)
    end

    subject { described_class.new(logger) }

    it 'returns the correct path' do
      expect(subject.path).to eq(path)
    end
  end
end
