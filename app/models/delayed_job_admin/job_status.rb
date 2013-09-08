class JobStatus
  attr_accessor :job_id, :job_status

  def initialize(id, status = Delayed::Job::PENDING)
    self.job_id = id
    self.job_status = status
  end

  def to_json
    { job_id: self.job_id, 
      job_status: self.job_status.to_s }.to_json
  end
end
