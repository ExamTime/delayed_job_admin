require "delayed_job_admin/engine"
require "delayed_job_active_record"
require "haml"

module DelayedJobAdmin
  mattr_accessor :destroy_handlers,
                 :default_poll_interval_in_secs,
                 :alert_thresholds,
                 :alert_strategies

  @@destroy_handlers = nil
  @@default_poll_interval_in_secs = nil
  @@alert_thresholds = nil
  @@alert_strategies = nil

  def self.setup
    yield self
  end
end
