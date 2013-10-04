require 'spec_helper'

describe DelayedJobAdmin::QueueChecker do
  let(:threshold_config){ {'dummy_queue' => 20, 'other_queue' => 99 } }
  let(:instance){ DelayedJobAdmin::QueueChecker.new(threshold_config) }

  it 'should be defined class' do
    DelayedJobAdmin::QueueChecker.should be_a Class
  end

  [ :check_queues, :queue_thresholds, :check_queue_against_threshold, :raise_queue_alert ].each do |method|
    it "should respond to the method '#{method}'" do
      instance.should respond_to method
    end
  end

  describe 'instantiation' do
    it 'should accept a Hash of configured queues to check' do
      checker = DelayedJobAdmin::QueueChecker.new(threshold_config)
      checker.should_not be_nil
      checker.queue_thresholds.should == threshold_config
    end

    it 'should raise and error if no config is passed' do
      lambda{ DelayedJobAdmin::QueueChecker.new }.should raise_error ArgumentError
    end

    it 'should raise an error unless passed a Hash' do
      lambda{ DelayedJobAdmin::QueueChecker.new(['Test', 'This']) }.should raise_error ArgumentError
    end
  end

  describe 'instance methods' do
    describe '#check_queues' do
      it 'should check the configured alert thresholds' do
        instance.should_receive(:check_queue_against_threshold).with('dummy_queue', 20)
        instance.should_receive(:check_queue_against_threshold).with('other_queue', 99)
        instance.check_queues
      end

      describe 'where a threshold has been exceeded' do
        let(:alert){ "Something" }

        it 'should loop through the configured set of alert strategies, instantiate and invoke the alert method' do
          instance.should_receive(:check_queue_against_threshold).with('dummy_queue', 20).and_return(nil)
          instance.should_receive(:check_queue_against_threshold).with('other_queue', 99).and_return(alert)
          instance.should_receive(:raise_queue_alert).with(alert)
          instance.check_queues
        end
      end
    end

    class DummyStrategy; end
    class AnotherDummyStrategy; end

    describe '#raise_queue_alert' do
      let(:dummy_alert){ double('dummy_alert') }
      let(:dummy_options){ { "test" => {} } }
      let(:dummy_config){ {DummyStrategy => dummy_options, AnotherDummyStrategy => dummy_options} }
      let(:dummy_strategy){ d = double('alert_strategy'); d.stub(:alert); d }

      it 'should loop over all the configured alert strategies, instantiate and issue the #alert call' do
        DelayedJobAdmin::alert_strategies = dummy_config
        dummy_config.each do |clazz, config|
          clazz.should_receive(:new).with(dummy_alert, dummy_options).and_return(dummy_strategy)
          dummy_strategy.should_receive(:alert)
        end
        instance.raise_queue_alert(dummy_alert)
      end

    end

    describe '#check_queue_against_threshold' do
      it 'should return a QueueAlert object for the alert if the queue_depth is exceeded' do
        Delayed::Job.stub_chain(:where, :count).and_return(6)
        result = instance.check_queue_against_threshold('test', 5)
        result.queue_name.should == 'test'
        result.queue_depth.should == 6
      end

      it 'should return nil if the queue_depth is not exceeded' do
        Delayed::Job.stub_chain(:where, :count).and_return(5)
        result = instance.check_queue_against_threshold('test', 5)
        result.should be_nil
      end
    end
  end

end
