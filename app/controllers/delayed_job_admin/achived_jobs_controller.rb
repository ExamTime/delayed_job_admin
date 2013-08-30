module DelayedJobAdmin
  class ArchivedJobsController < DelayedJobAdmin::ApplicationController
    def index
      @jobs = DelayedJobAdmin::ArchivedJob.all
    end
  end
end
