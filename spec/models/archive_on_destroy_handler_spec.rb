require 'spec_helper'

describe DelayedJobAdmin::ArchiveOnDestroyHandler do
  before :all do
    job = DummyModel.create(name: 'Model in queue').delay.method_to_queue('in queue')
    @handler = DelayedJobAdmin::ArchiveOnDestroyHandler.new(job)
  end

  [:handle, :job, :job=].each do |method|
    it "should respond_to the method :#{method}" do
      @handler.should respond_to method
    end
  end

  describe 'instantiation' do
    it 'should assign a single parameter to the instance variable @job' do
      test = 'This is a test'
      new = DelayedJobAdmin::ArchiveOnDestroyHandler.new(test)
      new.job.should == test
    end
  end

  describe 'instance method' do
    describe '#handle' do
      it "should destroy the Delayed::Job" do
        expect{ @handler.handle }.to change(Delayed::Job,:count).by(-1)
      end

      it "should move the job to the archive table" do
        expect{ @handler.handle }.to change(DelayedJobAdmin::ArchivedJob,:count).by(-1)
      end
    end
  end
end
