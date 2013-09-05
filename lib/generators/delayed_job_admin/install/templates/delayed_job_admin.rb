DelayedJobAdmin.setup do |config|
  # Configure an array of delete_handlers that will be called when the 
  # JobsController#delete action is invoked.
  # Each class in the list will be instantiated with a single argument,
  # representing the delayed_job of interest, i.e.
  #
  #     @handler = DelayedJobAdmin::ArchiveOnDeleteHandler.new(@job)
  #
  # The resulting @handler must have a #handle method, that should encapsulate
  # the logic to be executed when destroy is called.
  # The default behaviour is to archive the Delayed::Job in the delayed_job_admin_jobs_archive table.
  config.destroy_handlers = [ DelayedJobAdmin::ArchiveOnDestroyHandler ]

  # Configure details for the JS polling of the delayed_jobs table for status
  config.poll_interval_in_secs = 5
end
