require "delayed_job_admin/engine"
require "delayed_job_active_record"
require "haml"

module DelayedJobAdmin
  mattr_accessor :destroy_handlers
  @@destroy_handlers = nil

  def self.setup
    yield self
  end
end
