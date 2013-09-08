require 'spec_helper'

describe DelayedJobAdmin do
  it "should be defined" do
    DelayedJobAdmin.should be_a Module
  end

  describe "default config" do
    describe "destroy_handlers" do
      it "should be defined" do
        DelayedJobAdmin.destroy_handlers.should_not be_nil
      end

      it "should be an array with a single instance" do
        DelayedJobAdmin.destroy_handlers.should be_a Array
        DelayedJobAdmin.destroy_handlers.size.should == 1
      end

      it "should contain a default class of 'DelayedJobAdmin::ArchiveOnDestroyHandler'" do
        DelayedJobAdmin.destroy_handlers.first.should == DelayedJobAdmin::ArchiveOnDestroyHandler
      end
    end
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
