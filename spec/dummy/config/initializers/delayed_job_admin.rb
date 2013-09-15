DelayedJobAdmin.setup do |config|
  ##########################################################################################################
  #  JOB DELETION - delete_handlers
  ##########################################################################################################
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

  ##########################################################################################################
  #  QUEUE ALERTS - Thresholds
  ##########################################################################################################
  # A hash representation of the the threshold levels that should be monitored on the Delayed::Jobs table.
  # The threshold checker is quite simplistic, it just counts the total number of jobs in the named queue.
  # It makes no distinction between failing and pending jobs.
  # If there are failing jobs that are triggering your alert threshold you can:
  #     1. Change your alert threshold levels
  #     2. Remove the failing jobs to the archive table
  #
  # The default behaviour will just look at the total number of jobs in the queue and will raise an alert
  # if this value is over 20.
  # A more customized example may be, for example,
  #
  #     config.alert_thresholds = { 'mail' => 200, 'scrape' => 1000, 'default' => 1000 }
  #
  # Here we define that the individual named queues of 'mail' and 'scrape' should trigger thresholds when
  # the total number of Delayed::Jobs exceeds 200 and 1000, respectively.  Asides from these named queues,
  # we also stipulate that an alert should be raised any time the total queue depth exceeds 1000.
  config.alert_thresholds = { 'default' => 20 }

  ##########################################################################################################
  #  QUEUE ALERTS - Alert strategies
  ##########################################################################################################
  # Configure an array of alert_strategies that will be called when the JobsThresholdChecker raises a
  # ThresholdAlert. The key should be the class constant for the configured alert strategy, the value should
  # be an options hash that will be passed to the alert strategy on initialization.
  # Each class in the list will be instantiated with the ThresholdAlert that has been raised, and the set of
  # options configured below, e.g. the default behaviour will instantiate the EmailAlertStrategy as follows:
  #
  #     @alert_strategy = DelayedJobAdmin::EmailAlertStrategy.new( @alert, {emails: ['joe@example.com']} )
  #
  # The resulting @alert_strategy must have an #alert method which will be responsible for issuing the
  # threshold alert.
  # The default behaviour is to create a new mail job on the Delayed::Job queue.  Mails will be sent to all
  # of the emails listed in the options hash, i.e. the options hash for the EmailAlertStrategy MUST have a
  # key of :emails with at least one valid email, otherwise an ArgumentError will result.
  config.alert_strategies = { DelayedJobAdmin::EmailAlertStrategy => {emails: ['joe@example.com']} }
  
  ##########################################################################################################
  #  JOB POLLING
  ##########################################################################################################
  # Configure details for the JS polling of the delayed_jobs table for status
  config.default_poll_interval_in_secs = 5
end
