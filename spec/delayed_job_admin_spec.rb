require 'spec_helper'

describe DelayedJobAdmin do
  it "should be defined" do
    DelayedJobAdmin.should be_a Module
  end

  describe "dependency" do

    describe "DelayedJob" do
      let(:dummy_job) { DummyModel.create(name: "Dummy") }

      it "should have Delayed::Job defined" do
        Delayed::Job.should be_a Class
      end

      it "should add jobs to the delayed_jobs queue" do
        orig = Delayed::Job.all.size
        dummy_job.delay.method_to_queue("test job")
        Delayed::Job.all.size.should == orig + 1
      end
    end
  end
end
