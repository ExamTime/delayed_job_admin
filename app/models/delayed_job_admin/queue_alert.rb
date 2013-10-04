module DelayedJobAdmin
  class QueueAlert
    # There is a magic queue_name of __all__ to represent all queues
    attr_reader :queue_name, :queue_depth

    def initialize(queue_name, queue_depth)
      raise ArgumentError, 'The first parameter must specify a queue_name' unless queue_name
      raise ArgumentError, 'The second parameter must specify a queue_depth' unless queue_depth
      @queue_name = queue_name
      @queue_depth = queue_depth
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
