module DelayedJobAdmin
  class QueueChecker
    attr_reader :queue_thresholds

    def initialize(queue_thresholds)
      raise ArgumentError, instantiation_error_message unless (queue_thresholds && queue_thresholds.is_a?(Hash))
      @queue_thresholds = queue_thresholds
    end

    def check_queues
      queue_thresholds.each do |queue_name, threshold|
        alert = check_queue_against_threshold(queue_name, threshold)
        raise_queue_alert(alert) if alert
      end
    end

    def check_queue_against_threshold(queue_name, threshold)
      DelayedJobAdmin::QueueAlert.new(queue_name, threshold+1)
    end

    def raise_queue_alert(alert)

    end

    private

    def instantiation_error_message
      'QueueChecker must be instantiated with a Hash representing the configured alert thresholds for different queues'
    end
  end
end
