module DelayedJobAdmin
  class Engine < ::Rails::Engine
    isolate_namespace DelayedJobAdmin

    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w{ delayed_job_admin/jobs.css }
      Rails.application.config.assets.precompile += %w{ delayed_job_admin/poll_job.js delayed_job_admin/jobs.js }
    end

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
