require 'spec_helper'

describe Delayed::Job do
  before :all do
    @job = Delayed::Job.new
  end

  [:apply_handlers, :status].each do |method|
    it "should respond_to method :#{method}" do
      @job.should respond_to method
    end
  end

  describe 'namespaced constants' do
    %w( pending processing failing ).each do |state|
      name = "Delayed::Job::#{state.upcase}"
      describe name do
        it 'should be defined' do
          name.constantize.should_not be_nil
        end

        it 'should be a Delayed::Job::Status' do
          name.constantize.should be_a Delayed::Job::Status
        end

        it "should have a string representation of '#{state}'" do
          name.constantize.to_s.should == state
        end
      end
    end
  end

  describe 'instance method' do
    describe '#apply_handlers' do
      before :all do
        @cached_handlers = DelayedJobAdmin::destroy_handlers
        DelayedJobAdmin::destroy_handlers = [ DummyHandler ]
      end

      after :all do
        DelayedJobAdmin::destroy_handlers = @cached_handlers
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

    describe '#status' do
      it 'should return PENDING if locked_at is nil' do
        @job.locked_at = nil
        @job.status.should == Delayed::Job::PENDING
      end

      it 'should return PROCESSING if locked_at is not nil and failed_at is nil' do
        @job.locked_at = DateTime.now - 20.minutes
        @job.failed_at = nil
        @job.status.should == Delayed::Job::PROCESSING
      end

      it 'should return FAILING if locked_at is not nil and failed_at is not nil' do
        @job.locked_at = DateTime.now - 20.minutes
        @job.failed_at = DateTime.now - 10.minutes
        @job.status.should == Delayed::Job::FAILING
      end
    end

  end
end
