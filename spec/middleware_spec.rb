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
        expect{ server.get('/logput') }.to raise_exception
      end
    end

    context 'when rails is defined' do
      let(:logger) { double }
      let(:logvar) { double }
      let(:logdest) { double(:path => './spec/support/test.log') }

      before :each do
        class Rails
          def self.version
            @rails_version
          end

          def self.version=(v)
            @rails_version = v
          end
        end
      end

      context 'Rails 4' do
        before :each do
          Rails.version = '4.0.0'
          allow(logger).to receive(:instance_variable_get).with(:@logdev).and_return(logvar)
          allow(logvar).to receive(:instance_variable_get).with(:@dev).and_return(logdest)

          @request = server.get('/logput', { 'action_dispatch.logger' => logger })
        end

        it 'accesses the correct log file' do
          expect(@request.status).to eq(200)
        end
      end

      context 'Rails 3' do
        before :each do
          Rails.version = '3.0.0'
          allow(logger).to receive(:instance_variable_get).with(:@logger).and_return(logvar)
          allow(logvar).to receive(:instance_variable_get).with(:@log_dest).and_return(logdest)

          @request = server.get('/logput', { 'action_dispatch.logger' => logger })
        end

        it 'accesses the correct log file' do
          expect(server.get('/logput').status).to eq(200)
        end
      end
    end
  end

  describe '/logput' do
    context 'when there is no log file' do
      subject{ described_class.new(app, :path_to_log_file => './file_does_not_exist') }
      let(:server){ Rack::MockRequest.new(subject) }

      it 'raises an exception' do
        expect{ server.get('/logput')}.to raise_exception
      end
    end

    context 'when there is log file' do
      before :each do
        @response = server.get('/logput')
      end

      subject{ described_class.new(app, :path_to_log_file => './spec/support/test.log', :lines_to_read => 5) }
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
