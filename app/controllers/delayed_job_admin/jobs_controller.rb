module DelayedJobAdmin
  class JobsController < DelayedJobAdmin::ApplicationController
    def index
      @jobs = Delayed::Job.all
      render 'delayed_job_admin/shared/index'
    end

    def status
      job_id = params.fetch(:id).to_i
      json_response = { job_id: job_id, status: 'none' }

      job = Delayed::Job.where(id: job_id).first
      json_response[:status] = job.status.to_s if job

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
