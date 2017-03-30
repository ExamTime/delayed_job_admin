require 'spec_helper'

describe DelayedJobAdmin do
  it "should be defined" do
    expect(DelayedJobAdmin).to be_a Module
  end

  [ :destroy_handlers, :destroy_handlers=, :monitoring_strategies, :monitoring_strategies=,
    :alert_strategies, :alert_strategies=, :check_queues, :job_resource_name, :job_resource_name=,
    :archived_job_resource_name, :archived_job_resource_name=, :statuses_delayed_jobs_path,
    :statuses_delayed_jobs_path=, :pagination_jobs_per_page, :pagination_jobs_per_page= ].each do |method|
    it "should expose the method '#{method}'" do
      expect(DelayedJobAdmin).to respond_to method
    end
  end

  describe "default config" do
    describe "pagination_jobs_per_page" do
      it "should be defined" do
        expect(DelayedJobAdmin.pagination_jobs_per_page).not_to be_nil
      end

      it "should have a default value of '20'" do
        expect(DelayedJobAdmin.pagination_jobs_per_page).to eq(20)
      end
    end

    describe "job_resource_name" do
      it "should be defined" do
        expect(DelayedJobAdmin.job_resource_name).not_to be_nil
      end

      it "should have a default value of 'job'" do
        expect(DelayedJobAdmin.job_resource_name).to eq('job')
      end
    end

    describe "archived_job_resource_name" do
      it "should be defined" do
        expect(DelayedJobAdmin.archived_job_resource_name).not_to be_nil
      end

      it "should have a default value of 'job'" do
        expect(DelayedJobAdmin.archived_job_resource_name).to eq('archived_job')
      end
    end

    describe "statuses_delayed_jobs_path" do
      it "should be defined" do
        expect(DelayedJobAdmin.statuses_delayed_jobs_path).not_to be_nil
      end

      it "should have a default value of '/delayed_jobs/:job_ids/statuses'" do
        expect(DelayedJobAdmin.statuses_delayed_jobs_path).to eq('/delayed_jobs/:job_ids/statuses')
      end
    end

    describe "destroy_handlers" do
      it "should be defined" do
        expect(DelayedJobAdmin.destroy_handlers).not_to be_nil
      end

      it "should be an array with a single instance" do
        expect(DelayedJobAdmin.destroy_handlers).to be_a Array
        expect(DelayedJobAdmin.destroy_handlers.size).to eq(1)
      end

      it "should contain a default class of 'DelayedJobAdmin::ArchiveOnDestroyHandler'" do
        expect(DelayedJobAdmin.destroy_handlers.first).to eq(DelayedJobAdmin::ArchiveOnDestroyHandler)
      end
    end

    describe "monitoring_strategies" do
      it "should be defined" do
        expect(DelayedJobAdmin.monitoring_strategies).not_to be_nil
      end

      it "should be a hash with a single entry" do
        expect(DelayedJobAdmin.monitoring_strategies).to be_a Hash
        expect(DelayedJobAdmin.monitoring_strategies.size).to eq(1)
      end

      it "should contain a single entry for 'DelayedJobAdmin::QueueThresholdChecker'" do
        expect(DelayedJobAdmin.monitoring_strategies[DelayedJobAdmin::QueueThresholdChecker]).not_to be nil
      end

      it "should specify an overall queue threshold of 20" do
        queue_thresholds = DelayedJobAdmin.monitoring_strategies[DelayedJobAdmin::QueueThresholdChecker]
        expect(queue_thresholds['__all__']).to eq(20)
      end
    end

    describe "alert_strategies" do
      it "should be defined" do
        expect(DelayedJobAdmin.alert_strategies).not_to be_nil
      end

      it "should be a hash with a single instance" do
        expect(DelayedJobAdmin.alert_strategies).to be_a Hash
        expect(DelayedJobAdmin.alert_strategies.size).to eq(1)
      end

      describe "default configuration" do
        it "should contain a default class of 'DelayedJobAdmin::EmailAlertStrategy'" do
          expect(DelayedJobAdmin.alert_strategies.keys.first).to eq(DelayedJobAdmin::EmailAlertStrategy)
        end

        it "should have configured options hash with a single entry" do
          options = DelayedJobAdmin.alert_strategies.fetch(DelayedJobAdmin::EmailAlertStrategy)
          expect(options).to be_a Hash
          expect(options.size).to eq(1)
        end

        it "should have configured options with a key of :emails and an array of emails" do
          options = DelayedJobAdmin.alert_strategies[DelayedJobAdmin::EmailAlertStrategy]
          expect(options.keys).to include :emails
          expect(options.fetch(:emails)).to be_a Array
        end
      end
    end
  end


  describe "dependency" do

    describe "DelayedJob" do
      let(:dummy_job) { DummyModel.create(name: "Dummy") }

      it "should have Delayed::Job defined" do
        expect(Delayed::Job).to be_a Class
      end

      it "should add jobs to the delayed_jobs queue" do
        orig = Delayed::Job.all.size
        dummy_job.delay.method_to_queue("test job")
        expect(Delayed::Job.all.size).to eq(orig + 1)
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
        expect(DelayedJobAdmin::DummyChecker).to receive(:new).with(init_config).and_call_original
        expect(DelayedJobAdmin::AnotherDummyChecker).to receive(:new).with(another_init_config).and_call_original
        DelayedJobAdmin::check_queues
      end

      it 'should invoke the #run_check method on each monitoring strategy' do
        dummy_checker = double('dummy checker')
        another_dummy_checker = double('another dummy checker')
        expect(DelayedJobAdmin::DummyChecker).to receive(:new).and_return(dummy_checker)
        expect(DelayedJobAdmin::AnotherDummyChecker).to receive(:new).and_return(another_dummy_checker)
        expect(dummy_checker).to receive(:run_check)
        expect(another_dummy_checker).to receive(:run_check)
        DelayedJobAdmin::check_queues
      end
    end
  end
end
