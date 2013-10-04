require 'spec_helper'

describe DelayedJobAdmin::QueueAlert do
  let(:instance) { DelayedJobAdmin::QueueAlert.new('__default__', 500) }

  it 'should be defined' do
    DelayedJobAdmin::QueueAlert.should_not be_nil
  end

  [ :queue_name, :queue_depth ].each do |method|
    it "should respond to the method '#{method}'" do
      instance.should respond_to method
    end
  end

  describe 'instantiation' do
    it 'should be successfully instantiated if supplied all required parameters' do
      DelayedJobAdmin::QueueAlert.new('testy', 99).should_not be_nil
    end

    it 'should be successfully set the queue_depth to the value supplied' do
      DelayedJobAdmin::QueueAlert.new('testy', 99).queue_depth.should == 99
    end

    it 'should raise an error if the queue_name is not supplied' do
      lambda{ DelayedJobAdmin::QueueAlert.new(nil, 99) }.should raise_error ArgumentError
    end

    it 'should raise an error if the queue depth is not supplied' do
      lambda{ DelayedJobAdmin::QueueAlert.new('testy', nil) }.should raise_error ArgumentError
    end


    it 'should set the queue_name appropriately if this is supplied by the user' do
      DelayedJobAdmin::QueueAlert.new('testy', 99).queue_name.should == 'testy'
    end
  end

  describe 'instance method' do
    describe '#all_queues?' do
      it "should return true when the queue is named 'default' queue" do
        DelayedJobAdmin::QueueAlert.new('__all__', 10).all_queues?.should be_true
      end

      it "should return false when the queue is not named '__default__'" do
        DelayedJobAdmin::QueueAlert.new('testy', 10).all_queues?.should be_false
      end
    end

    describe '#alert_message' do
      [ [ '__all__', 5, "There are currently 5 queued delayed_jobs." ],
        [ 'scrape', 10, "There are currently 10 queued delayed_jobs in the 'scrape' queue." ] ].each do |test|
        it "should generate a message of '#{test[3]}' when supplied a queue_depth of '#{test[0]}' and a queue_name of '#{test[1]}'" do
          alert = DelayedJobAdmin::QueueAlert.new(test[0], test[1])
          alert.alert_message.should == test[2]
        end
      end
    end
  end

end
