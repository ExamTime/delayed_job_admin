namespace :delayed_job_admin do
  desc "Task to run the configured queue monitoring logic"
  task :check_queues do
    DelayedJobAdmin::check_queues
  end
end
