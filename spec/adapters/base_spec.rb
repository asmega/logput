require 'spec_helper'

class UnRegisteredAdapter < Logput::Adapters::Base
end

describe Logput::Adapters::Base do
  describe '.register' do
    after :each do
      Logput::Adapters.registered_adapters.delete(:test)
    end

    it 'adds the current adapter to the registry' do
      expect(Logput::Adapters.registered_adapters[:test]).to eq(nil)
      UnRegisteredAdapter.register :test
      expect(Logput::Adapters.registered_adapters[:test]).to eq(UnRegisteredAdapter)
    end
  end

  describe '.handles?' do
    it 'raises a NotImplementedError' do
      expect {
        described_class.handles?(double)
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#path' do
    subject { described_class.new(:foo) }

    it 'raises a NotImplementedError' do
      expect {
        subject.path
      }.to raise_error(NotImplementedError)
    end
  end
end
