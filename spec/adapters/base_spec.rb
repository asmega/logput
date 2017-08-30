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

  describe '#path_override' do
    subject { described_class.new(:foo) }

    after :each do
      ENV['LOG_NAME'] = nil
      ENV['LOG_LOCATION_DIR'] = nil
    end

    it 'returns nil if environment variables are not set' do
      expect(subject.path_override).to eq(nil)
    end

    it 'returns a path if the environment variables are set' do
      ENV['LOG_NAME'] = 'development'
      ENV['LOG_LOCATION_DIR'] = 'logs'
      expect(subject.path_override).to eq('logs/development.log')
    end


  end
end
