require 'spec_helper'

describe Delayed::Job do
  before :all do
    @job = Delayed::Job.new
  end

  [:apply_handlers].each do |method|
    it "should respond_to method :#{method}" do
      @job.should respond_to method
    end
  end

  describe 'instance method' do
    describe '#apply_handlers' do
      before :all do
        DelayedJobAdmin::destroy_handlers = [ DummyHandler ]
      end

      it 'should create a destroy handler for each class configured' do
        handler = DummyHandler.new(@job)
        DummyHandler.should_receive(:new).with(@job).once.and_return(handler)
        @job.apply_handlers
      end

      it 'should invoke the #handle method on each of the created destroy handlers' do
        handler_mock = double('handler_mock')
        DummyHandler.should_receive(:new).and_return(handler_mock)
        handler_mock.should_receive(:handle).once
        @job.apply_handlers
      end
    end

  end
end
