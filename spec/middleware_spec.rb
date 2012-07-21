require 'spec_helper'

describe Logput::Middleware do
  subject{ described_class.new(app, :path_to_log_file => './spec/support/test.log') }

  let(:app) do
    lambda do |env|
      [200, {}, "hello world"]
    end
  end

  let(:server){ Rack::MockRequest.new(subject) }

  describe '/wrong_path' do
    before :each do
      @response = server.get('/wrong_path')
    end

    it 'outputs hello world' do
      @response.body.should include('hello world')
    end
  end

  describe 'default path to log file' do
    subject { described_class.new(app) }

    context 'when rails is not defined' do
      it 'raises an error' do
        expect{ subject }.to raise_exception
      end
    end

    context 'when rails is defined' do
      before :each do
        class Rails; end
      end

      it 'returns ./log/development.log' do
        subject.instance_variable_get(:@path_to_log_file).should == './log/development.log'
      end
    end
  end

  describe '/logput' do
    before :each do
      @response = server.get('/logput')
    end

    context 'when there is no log file' do
      let(:server){ Rack::MockRequest.new(described_class.new(app)) }

      it 'returns a 404' do
        @response.status.should == 404
      end

      it 'tells the user no log file can be found' do
        @response.body.should include('not found')
      end
    end

    context 'when there is log file' do
      let(:server){ Rack::MockRequest.new(subject) }

      it 'responds with 200' do
        @response.status.should == 200
      end

      it 'returns the last 5 lines of the log' do
        @response.body.should_not include('2')
        @response.body.should_not include('5')

        @response.body.should include('6')
        @response.body.should include('10')
      end
    end
  end
end
