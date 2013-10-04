module DelayedJobAdmin
  class QueueAlert
    # There is a magic queue_name of __all__ to represent all queues
    attr_reader :queue_name, :queue_depth, :queue_threshold

    def initialize(queue_name, queue_depth, queue_threshold)
      raise ArgumentError, 'The first parameter must specify a queue_name' unless queue_name
      raise ArgumentError, 'The second parameter must specify a queue_depth' unless queue_depth
      raise ArgumentError, 'The third parameter must specify a queue_threshold' unless queue_threshold
      @queue_name = queue_name
      @queue_depth = queue_depth
      @queue_threshold = queue_threshold
    end

    def alert_message
      msg = "There are currently #{queue_depth} queued delayed_jobs"
      msg += " in the '#{queue_name}' queue" unless all_queues?
      msg += "."
    end

    def all_queues?
      queue_name=='__all__'
    end
  end
end
