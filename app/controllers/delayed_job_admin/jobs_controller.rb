module DelayedJobAdmin
  class JobsController < DelayedJobAdmin::ApplicationController
    include DelayedJobAdmin::AccessibleJobs
  end
end
