require 'spec_helper'

describe DelayedJobAdmin do
  it "should be defined" do
    DelayedJobAdmin.should be_a Module
  end

  [ :destroy_handlers, :destroy_handlers=, :monitoring_strategies, :monitoring_strategies=, 
    :alert_strategies, :alert_strategies=, :check_queues ].each do |method|
    it "should expose the method '#{method}'" do
      DelayedJobAdmin.should respond_to method
    end
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

    describe "monitoring_strategies" do
      it "should be defined" do
        DelayedJobAdmin.monitoring_strategies.should_not be_nil
      end

      it "should be a hash with a single entry" do
        DelayedJobAdmin.monitoring_strategies.should be_a Hash
        DelayedJobAdmin.monitoring_strategies.size.should == 1
      end

      it "should contain a single entry for 'DelayedJobAdmin::QueueThresholdChecker'" do
        DelayedJobAdmin.monitoring_strategies[DelayedJobAdmin::QueueThresholdChecker].should_not be nil
      end

      it "should specify an overall queue threshold of 20" do
        queue_thresholds = DelayedJobAdmin.monitoring_strategies[DelayedJobAdmin::QueueThresholdChecker]
        queue_thresholds['__all__'].should == 20
      end
    end

    describe "alert_strategies" do
      it "should be defined" do
        DelayedJobAdmin.alert_strategies.should_not be_nil
      end

      it "should be a hash with a single instance" do
        DelayedJobAdmin.alert_strategies.should be_a Hash
        DelayedJobAdmin.alert_strategies.size.should == 1
      end

      describe "default configuration" do
        it "should contain a default class of 'DelayedJobAdmin::EmailAlertStrategy'" do
          DelayedJobAdmin.alert_strategies.keys.first.should == DelayedJobAdmin::EmailAlertStrategy
        end

        it "should have configured options hash with a single entry" do
          options = DelayedJobAdmin.alert_strategies.fetch(DelayedJobAdmin::EmailAlertStrategy)
          options.should be_a Hash
          options.size.should == 1
        end

        it "should have configured options with a key of :emails and an array of emails" do
          options = DelayedJobAdmin.alert_strategies[DelayedJobAdmin::EmailAlertStrategy]
          options.keys.should include :emails
          options.fetch(:emails).should be_a Array
        end
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

  class DelayedJobAdmin::DummyChecker
    def initialize(options = {}); end
    def run_check; end
  end

  class DelayedJobAdmin::AnotherDummyChecker < DelayedJobAdmin::DummyChecker
  end

  describe 'module level function' do
    describe '::check_queues' do
      let(:init_config) { {test: 'test_val'} }
      let(:another_init_config) { {another_test: 'another test val'} }

      before :all do
        @orig_config = DelayedJobAdmin.monitoring_strategies
      end

      before :each do
        DelayedJobAdmin.monitoring_strategies = {
          DelayedJobAdmin::DummyChecker => init_config,
          DelayedJobAdmin::AnotherDummyChecker => another_init_config
        }
      end

      after :all do
        DelayedJobAdmin.monitoring_strategies = @orig_config
      end

      it 'should loop through each configured DelayedJobAdmin::monitoring_strategies and instantiate' do
        DelayedJobAdmin::DummyChecker.should_receive(:new).with(init_config).and_call_original
        DelayedJobAdmin::AnotherDummyChecker.should_receive(:new).with(another_init_config).and_call_original
        DelayedJobAdmin::check_queues
      end

      it 'should invoke the #run_check method on each monitoring strategy' do
        dummy_checker = double('dummy checker')
        another_dummy_checker = double('another dummy checker')
        DelayedJobAdmin::DummyChecker.should_receive(:new).and_return(dummy_checker)
        DelayedJobAdmin::AnotherDummyChecker.should_receive(:new).and_return(another_dummy_checker)
        dummy_checker.should_receive(:run_check)
        another_dummy_checker.should_receive(:run_check)
        DelayedJobAdmin::check_queues
      end
    end
  end
end
