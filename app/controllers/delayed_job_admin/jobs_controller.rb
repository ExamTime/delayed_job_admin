module DelayedJobAdmin
  class JobsController < DelayedJobAdmin::ApplicationController
    def index
      @jobs = Delayed::Job.all
    end

    def status
      job_id = params.fetch(:id).to_i
      json_response = { job_id: job_id, status: 'none' }

      job = Delayed::Job.where(id: job_id).first
=begin
      if job
        json_response[:status] = job.failed? ? 'failing' : 'pending'
      end
=end
      json_response[:status] = job.status if job
      render json: json_response
    end

    def destroy
      @job = Delayed::Job.find(params.fetch(:id).to_i)
      success = true
      begin
        @job.apply_handlers
        redirect_to jobs_url, flash: { notice: I18n.t('delayed_job_admin.destroy_job.success') }
      rescue StandardError => e
        Rails.logger.warn("#{e.message}:\n\n #{e.backtrace}")
        redirect_to jobs_url, flash: { error: I18n.t('delayed_job_admin.destroy_job.failure') }
      end
    end
  end
end
