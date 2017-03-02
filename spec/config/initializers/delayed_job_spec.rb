require 'spec_helper'

describe Delayed::Job do
  before :each do
    @job = Delayed::Job.new
  end

  [:apply_handlers, :status].each do |method|
    it "should respond_to method :#{method}" do
      expect(@job).to respond_to method
    end
  end

  describe 'namespaced constants' do
    %w( pending processing failing ).each do |state|
      name = "Delayed::Job::#{state.upcase}"
      describe name do
        it 'should be defined' do
          expect(name.constantize).not_to be_nil
        end

        it 'should be a Delayed::Job::Status' do
          expect(name.constantize).to be_a Delayed::Job::Status
        end

        it "should have a string representation of '#{state}'" do
          expect(name.constantize.to_s).to eq(state)
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
        expect(DummyHandler).to receive(:new).with(@job).once.and_return(handler)
        @job.apply_handlers
      end

      it 'should invoke the #handle method on each of the created destroy handlers' do
        handler_mock = double('handler_mock')
        expect(DummyHandler).to receive(:new).and_return(handler_mock)
        expect(handler_mock).to receive(:handle).once
        @job.apply_handlers
      end
    end

    describe '#status' do
      context 'where failed_at and last_error are both nil' do
        before :each do
          @job.failed_at = nil
          @job.last_error = nil
        end

        it 'should return PENDING if locked_at is nil' do
          @job.locked_at = nil
          expect(@job.status).to eq(Delayed::Job::PENDING)
        end

        it 'should return PROCESSING if locked_at is not nil' do
          @job.locked_at = DateTime.now - 20.minutes
          expect(@job.status).to eq(Delayed::Job::PROCESSING)
        end
      end

      it 'should return FAILING if last_error is not nil' do
        @job.last_error = 'Failed job'
        expect(@job.status).to eq(Delayed::Job::FAILING)
      end

      it 'should return FAILED if failed_at is not nil' do
        @job.failed_at = DateTime.now - 20.minutes
        expect(@job.status).to eq(Delayed::Job::FAILED)
      end
    end

  end
end
