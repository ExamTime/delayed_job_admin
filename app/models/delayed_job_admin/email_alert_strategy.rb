module DelayedJobAdmin
  class EmailAlertStrategy
    attr_accessor :queue_alert, :emails

    def initialize(queue_alert, options = {})
      raise ArgumentError, "EmailAlertStrategy must be passed an alert" unless queue_alert
      emails = options.fetch(:emails){ raise ArgumentError, "Initialization requires an options hash with an :emails key." }
      @queue_alert = queue_alert
      @emails = emails
    end

    def alert
      DelayedJobAdmin::QueueThresholdAlertMailer.send_alert(queue_alert, emails).deliver
    end
  end
end
