module DelayedJobAdmin
  class ArchivedJobsController < DelayedJobAdmin::ApplicationController
    include DelayedJobAdmin::AccessibleArchivedJobs
  end
end
