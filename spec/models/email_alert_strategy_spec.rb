require 'spec_helper'

describe DelayedJobAdmin::EmailAlertStrategy do
  let(:dummy_alert) { double('alert') }
  let(:instance){ DelayedJobAdmin::EmailAlertStrategy.new(dummy_alert, { emails: 'joe@example.com' }) }

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
    end

  end

  describe 'instance method' do
    describe '#alert' do
      it 'should invoke the #send_alert method on the QueueThresholdAlertMailer' do
      end
    end
  end
end
