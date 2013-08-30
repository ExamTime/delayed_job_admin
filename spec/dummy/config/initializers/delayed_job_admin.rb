DelayedJobAdmin.setup do |config|
  # Configure an array of delete_handlers that will be called when the 
  # JobsController#delete action is invoked.
  # Each class in the list will be instantiated with a single argument,
  # representing the delayed_job of interest, i.e.
  #
  #     @handler = DelayedJobAdmin::ArchiveOnDeleteHandler.new(@job)
  #
  # The resulting @handler must have a #handle_delete method, that should 
  # encapsulate the logic on deletion.
  # The default behaviour is to archive the Delayed::Job in the delayed_job_admin_jobs_archive table.
  config.destroy_handlers = [ 'DelayedJobAdmin::ArchiveOnDestroyHandler' ]
end
