module DelayedJobAdmin
  module AccessibleArchivedJobs
    def index
      @jobs = DelayedJobAdmin::ArchivedJob.page(params[:page]).per(DelayedJobAdmin::pagination_jobs_per_page)
      @archive = true
      render 'delayed_job_admin/shared/index'
    end
  end
end
