require 'spec_helper'

describe DelayedJobAdmin::EmailAlertStrategy do
  let(:dummy_alert) { DelayedJobAdmin::QueueAlert.new('Dummy queue', 10, 5) }
  let(:emails) { ['joe@example.com', 'zoe@example.com'] }
  let(:instance){ DelayedJobAdmin::EmailAlertStrategy.new(dummy_alert, { emails: emails }) }

  it 'should be defined' do
    DelayedJobAdmin::EmailAlertStrategy.should_not be_nil
  end

  [ :alert ].each do |method|
    it "should respond to the #{method}" do
      instance.should respond_to method
    end
  end

  describe 'instantiation' do
    it 'should be possible when all required arguments are supplied' do
      instance.should_not be_nil
    end

    it 'should raise an ArgumentError if a queue alert is not supplied' do
      lambda{ DelayedJobAdmin::EmailAlertStrategy.new(nil, {}) }.should raise_error ArgumentError
    end

    it 'should raise an ArgumentError if the options hash does not include an :emails key' do
      lambda{ DelayedJobAdmin::EmailAlertStrategy.new('dummy', {emailer: emails}) }.should raise_error ArgumentError
    end
  end

  describe 'instance method' do
    describe '#alert' do
      it 'should invoke the #send_alert method on the DelayedJobAdmin::QueueThresholdAlertMailer' do
        DelayedJobAdmin::QueueThresholdAlertMailer.should_receive(:send_alert).with(dummy_alert, emails).and_call_original
        instance.alert
      end
    end
  end
end
