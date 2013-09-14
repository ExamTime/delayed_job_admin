class Delayed::Job
  class Status
    attr_accessor :name

    def initialize(name)
      self.name = name
    end

    def to_s
      self.name
    end

    def ==(another_status)
      self.name == another_status.name
    end
  end

  PENDING = Status.new('pending').freeze
  PROCESSING = Status.new('processing').freeze
  FAILING = Status.new('failing').freeze
  FAILED = Status.new('failed').freeze

  def apply_handlers
    DelayedJobAdmin.destroy_handlers.each do |clazz|
      handler = clazz.new(self)
      handler.handle
    end
  end

  def status
    return FAILED if self.failed_at
    return FAILING if self.last_error
    self.locked_at ? PROCESSING : PENDING
  end
end
