require 'spec_helper'

describe DelayedJobAdmin::QueueAlert do
  let(:instance) { DelayedJobAdmin::QueueAlert.new('__all__', 500, 200) }

  it 'should be defined' do
    expect(DelayedJobAdmin::QueueAlert).not_to be_nil
  end

  [ :queue_name, :queue_depth, :queue_threshold ].each do |method|
    it "should respond to the method '#{method}'" do
      expect(instance).to respond_to method
    end
  end

  describe 'instantiation' do
    it 'should be successfully instantiated if supplied all required parameters' do
      expect(DelayedJobAdmin::QueueAlert.new('testy', 99, 100)).not_to be_nil
    end

    it 'should be successfully set the queue_depth to the value supplied' do
      expect(DelayedJobAdmin::QueueAlert.new('testy', 99, 100).queue_depth).to eq(99)
    end

    it 'should raise an error if the queue_name is not supplied' do
      expect{ DelayedJobAdmin::QueueAlert.new(nil, 99, 100) }.to raise_error ArgumentError
    end

    it 'should raise an error if the queue depth is not supplied' do
      expect{ DelayedJobAdmin::QueueAlert.new('testy', nil, 100) }.to raise_error ArgumentError
    end

    it 'should raise an error if the queue threshold is not supplied' do
      expect{ DelayedJobAdmin::QueueAlert.new('testy', 99, nil) }.to raise_error ArgumentError
    end

    it 'should set the queue_name appropriately if this is supplied by the user' do
      expect(DelayedJobAdmin::QueueAlert.new('testy', 99, 100).queue_name).to eq('testy')
    end

    it 'should set the queue_threshold appropriately if this is supplied by the user' do
      expect(DelayedJobAdmin::QueueAlert.new('testy', 99, 200).queue_threshold).to eq(200)
    end
  end

  describe 'instance method' do
    describe '#all_queues?' do
      it "should return true when the queue is named 'default' queue" do
        expect(DelayedJobAdmin::QueueAlert.new('__all__', 10, 10).all_queues?).to be_truthy
      end

      it "should return false when the queue is not named '__default__'" do
        expect(DelayedJobAdmin::QueueAlert.new('testy', 10, 10).all_queues?).to be_falsey
      end
    end

    describe '#alert_message' do
      [ [ '__all__', 5, 99, "There are currently 5 queued delayed_jobs." ],
        [ 'scrape', 10, 99, "There are currently 10 queued delayed_jobs in the 'scrape' queue." ] ].each do |test|
        it "should generate a message of '#{test[3]}' when supplied a queue_depth of '#{test[0]}' and a queue_name of '#{test[1]}'" do
          alert = DelayedJobAdmin::QueueAlert.new(test[0], test[1], test[2])
          expect(alert.alert_message).to eq(test[3])
        end
      end
    end
  end

end
