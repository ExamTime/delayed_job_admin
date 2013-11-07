module DelayedJobAdmin
  class QueueThresholdAlertMailer
    def send_alert(alert, emails)
      @alert = alert
      mail(to: emails,
           subject: I18n.t('delayed_job_admin.queue_thershold_alert_mailer.send_alert.subject',
                           queue_name: alert.queue_name,
                           threshold: alert.threshold) )
    end
  end
end
