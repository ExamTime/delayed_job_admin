module DelayedJobAdmin
  class EmailAlertStrategy
=begin
    attr_accessor :job, :audit_log

    def initialize(job, audit_log='<blank>')
      self.job = job
      self.audit_log = audit_log
    end

    def handle
      ActiveRecord::Base.transaction do
        DelayedJobAdmin::ArchivedJob.create!(job: self.job, archive_note: audit_log)
        job.destroy
      end
    end
=end
  end
end
