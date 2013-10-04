module DelayedJobAdmin
  class EmailAlertStrategy
    attr_accessor :queue_alert, :emails

    def initialize(queue_alert, emails)
      raise ArgumentError, "EmailAlertStrategy must be passed an alert" unless queue_alert
      raise ArgumentError, "EmailAlertStrategy must be passed an emails array" unless emails
      @queue_alert = queue_alert
      @emails = emails
    end

    def alert

      mail(:to => emails.join(','), subject: alert_message)
    end
  end
end
