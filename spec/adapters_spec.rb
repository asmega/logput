require 'spec_helper'

class TestAdapter
  def initialize(logger); end
  def self.handles?(logger); false; end
end

describe Logput::Adapters do

  describe '.registered_adapters' do
    let(:expected) {{
      logger: Logput::Adapters::Logger,
      tagged_logging: Logput::Adapters::TaggedLogging
    }}

    it 'returns a hash of registered adapters' do
      expect(described_class.registered_adapters).to eq(expected)
    end
  end

  describe '.obtain' do
    before :each do
      Logput::Adapters.registered_adapters[:test] = TestAdapter
    end

    context 'when an adapter matches' do
      it 'returns an instance of a matching adapter' do
        allow(TestAdapter).to receive(:handles?).with(:bar).and_return(true)
        expect(described_class.obtain(:bar)).to be_a(TestAdapter)
      end
    end

    context 'when no adapter matches' do
      it 'raises a logger not supported exception' do
        expect {
          described_class.obtain(:foo)
        }.to raise_error
      end
    end
  end
end
