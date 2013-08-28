module DelayedJobAdmin
  class JobsController < DelayedJobAdmin::ApplicationController
    def index
      @jobs = Delayed::Job.all
    end

    def status
      job_id = params[:id].to_i
      json_response = { job_id: job_id, status: 'none' }

      job = Delayed::Job.where(id: job_id).first
      if job
        json_response[:status] = job.failed? ? 'failing' : 'pending'
      end
      render json: json_response
    end
  end
end
