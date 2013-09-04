require 'spec_helper'

describe DelayedJobAdmin::ArchiveOnDestroyHandler do
  before :all do
    job = DummyModel.create(name: 'Model in queue').delay.method_to_queue('in queue')
    @handler = DelayedJobAdmin::ArchiveOnDestroyHandler.new(job)
  end

  [:handle, :job, :job=, :audit_log, :audit_log=].each do |method|
    it "should respond_to the method :#{method}" do
      @handler.should respond_to method
    end
  end

  describe 'instantiation' do
    it 'should assign first parameter to the instance variable @job' do
      test = 'This is a test'
      DelayedJobAdmin::ArchiveOnDestroyHandler.new(test).job.should == test
    end

    it 'should fail if first parameter is not supplied for @job' do
      lambda{ DelayedJobAdmin::ArchiveOnDestroyHandler.new }.should raise_error StandardError
    end

    it 'should assign the second parameter to @audit_log if supplied' do
      audit_log = 'audit'
      DelayedJobAdmin::ArchiveOnDestroyHandler.new('job', audit_log).audit_log.should == audit_log
    end

    it 'should default the @audit_log to <blank> if not supplied' do
      DelayedJobAdmin::ArchiveOnDestroyHandler.new('job').audit_log.should == '<blank>'
    end
  end

  describe 'instance method' do
    describe '#handle' do
      it "should destroy the Delayed::Job" do
        expect{ @handler.handle }.to change(Delayed::Job,:count).by(-1)
      end

      it "should move the job to the archive table" do
        expect{ @handler.handle }.to change(DelayedJobAdmin::ArchivedJob,:count).by(1)
      end
    end
  end
end
