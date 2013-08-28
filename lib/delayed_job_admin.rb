require "delayed_job_admin/engine"
require "delayed_job_active_record"
require "haml"

module DelayedJobAdmin
  mattr_accessor :authorization_strategy
  @@authorization_strategy = nil

  mattr_accessor :supported_actions
  @@supported_actions = [:view, :edit, :delete, :extend]

  def self.setup
    yield self
  end
end
