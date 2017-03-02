require 'spec_helper'

describe DelayedJobAdmin::EmailAlertStrategy do
  let(:dummy_alert) { DelayedJobAdmin::QueueAlert.new('Dummy queue', 10, 5) }
  let(:emails) { ['joe@example.com', 'zoe@example.com'] }
  let(:instance){ DelayedJobAdmin::EmailAlertStrategy.new(dummy_alert, { emails: emails }) }

  it 'should be defined' do
    expect(DelayedJobAdmin::EmailAlertStrategy).not_to be_nil
  end

  [ :alert ].each do |method|
    it "should respond to the #{method}" do
      expect(instance).to respond_to method
    end
  end

  describe 'instantiation' do
    it 'should be possible when all required arguments are supplied' do
      expect(instance).not_to be_nil
    end

    it 'should raise an ArgumentError if a queue alert is not supplied' do
      expect{ DelayedJobAdmin::EmailAlertStrategy.new(nil, {}) }.to raise_error ArgumentError
    end

    it 'should raise an ArgumentError if the options hash does not include an :emails key' do
      expect{ DelayedJobAdmin::EmailAlertStrategy.new('dummy', {emailer: emails}) }.to raise_error ArgumentError
    end
  end

  describe 'instance method' do
    describe '#alert' do
      it 'should invoke the #send_alert method on the DelayedJobAdmin::QueueThresholdAlertMailer' do
        expect(DelayedJobAdmin::QueueThresholdAlertMailer).to receive(:send_alert).with(dummy_alert, emails).and_call_original
        instance.alert
      end
    end
  end
end
