module DelayedJobAdmin
  class ArchivedJob < ActiveRecord::Base
    attr_accessible :job, :archived_at, :archive_note, :datetime_generator

    validates :archived_at, presence: true
    validates :archive_note, presence: true

    after_initialize :set_default_archived_at_date

    def job=(job)
      self.id = job.id
      self.priority = job.priority
      self.attempts = job.attempts
      self.handler = job.handler
      self.last_error = job.last_error
      self.run_at = job.run_at
      self.locked_at = job.locked_at
      self.failed_at = job.failed_at
      self.locked_by = job.locked_by
      self.queue = job.queue
      self.created_at = job.created_at
      self.updated_at = job.updated_at
    end

    def datetime_generator
      return @datetime_generator if @datetime_generator
      self.datetime_generator = DefaultDateTimeGenerator.new
    end

    def datetime_generator=(generator)
      @datetime_generator = generator
    end

    private

    def set_default_archived_at_date
      self.archived_at = datetime_generator.get_datetime unless self.archived_at
    end

  end

  class DefaultDateTimeGenerator
    def initialize
      @datetime = DateTime.now
    end

    def get_datetime
      @datetime
    end
  end
end
