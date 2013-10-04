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

    describe '#raise_queue_alert' do
    end

    describe '#check_queue_against_threshold' do
    end
  end

end
