module DelayedJobAdmin
  module AccessibleArchivedJobs
    def index
      @jobs = DelayedJobAdmin::ArchivedJob.all
      @archive = true
      render 'delayed_job_admin/shared/index'
    end
  end
end
