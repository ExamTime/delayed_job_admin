module DelayedJobAdmin
  module AccessibleArchivedJobs
    def index
      @archive = true
      @jobs = DelayedJobAdmin::ArchivedJob.page(params[:page])
                                          .per(DelayedJobAdmin::pagination_jobs_per_page)
      if blacklist = DelayedJobAdmin.pagination_excluding_queues
        @jobs = DelayedJobAdmin::ArchivedJob.where("queue IS NULL OR queue NOT IN (?)", blacklist)
      end

      render 'delayed_job_admin/shared/index'
    end
  end
end
