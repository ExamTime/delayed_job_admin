module DelayedJobAdmin
  class ArchivedJobsController < DelayedJobAdmin::ApplicationController
    def index
      @jobs = DelayedJobAdmin::ArchivedJob.all
      @archive = true
      render 'delayed_job_admin/shared/index'
    end
  end
end
