require "delayed_job_admin/engine"
require "delayed_job_active_record"
require "haml"

module DelayedJobAdmin
  mattr_accessor :destroy_handlers,
                 :default_poll_interval_in_secs,
                 :monitoring_strategies,
                 :alert_strategies

  @@destroy_handlers = nil
  @@default_poll_interval_in_secs = nil
  @@monitoring_strategies = nil
  @@alert_strategies = nil

  def self.setup
    yield self
  end

  def self.check_queues
    DelayedJobAdmin.monitoring_strategies.each do |clazz, init_config|
      checker = clazz.new(init_config)
      checker.run_check
    end
  end
end
