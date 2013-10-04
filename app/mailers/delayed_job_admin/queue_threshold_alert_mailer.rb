module DelayedJobAdmin
  class QueueThresholdAlertMailer
    def send_alert(alert, emails)
      mail(to: emails,
           subject: I18n.t('delayed_job_admin.alert_strategies.alert_email.subject',
                           queue_name: alert.queue_name,
                           threshold: alert.threshold) )
    end
  end
end
