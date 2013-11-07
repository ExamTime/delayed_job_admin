$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "delayed_job_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "delayed_job_admin"
  s.version     = DelayedJobAdmin::VERSION
  s.authors     = ["Domhnall Murphy"]
  s.email       = ["domhnallmurphy@hotmail.com"]
  s.homepage    = ""
  s.summary     = "Engine to offer views and actions on your delayed job queue"
  s.description = "Engine to offer views and actions on your delayed job queue"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.14"
  s.add_dependency "delayed_job_active_record"
  s.add_dependency 'haml'
  s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'

  s.test_files = Dir["spec/**/*"]

end
