module DelayedJobAdmin
  class ArchiveOnDestroyHandler
    attr_accessor :job

    def initialize(job)
      self.job = job
    end

    def handle
    end
  end
end
