DelayedJobAdmin.setup do |config|
  # This class will be instantiated as follows:
  # DelayedJobAdmin::DefaultAuthorizationStrategy.new(Delayed::Job = nil) 
  config.authorization_strategy = 'DelayedJobAdmin::DefaultAuthorizationStrategy'
end
