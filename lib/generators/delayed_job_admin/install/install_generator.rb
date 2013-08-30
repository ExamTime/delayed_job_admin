require 'rails/generators/migration'

module DelayedJobAdmin
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "Adding the delayed_job_admin migrations to the host app"

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template "create_delayed_job_admin_archived_jobs.rb", "db/migrate/create_delayed_job_admin_archived_jobs.rb"
        template "delayed_job_admin.rb", "config/initializers/delayed_job_admin.rb"
        template "delayed_job_admin.en.yml", "config/locales/delayed_job_admin.en.yml"
      end
    end
  end
end
