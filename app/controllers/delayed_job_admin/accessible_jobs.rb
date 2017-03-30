module DelayedJobAdmin
  module AccessibleJobs
    def index
      @jobs = Delayed::Job.page(params[:page])
                          .per(DelayedJobAdmin::pagination_jobs_per_page)
      if( (blacklist = DelayedJobAdmin.pagination_excluding_queues) && !blacklist.blank? )
        @jobs = @jobs.where("queue IS NULL OR queue NOT IN (?)", blacklist)
      end

      render 'delayed_job_admin/shared/index'
    end

    def job_statuses
      job_ids = params.fetch(:job_ids).split(',')

      json_response = Delayed::Job.where(id: job_ids).map { |job|
        json_status = { job_id: job.id, status: 'none' }
        json_status[:status] = job.status.to_s
        json_status
      }

      render json: json_response
    end

    def destroy
      @job = Delayed::Job.find(params.fetch(:id).to_i)
      success = true
      target_url = self.send("#{DelayedJobAdmin::job_resource_name.pluralize}_url")
      begin
        @job.apply_handlers
        redirect_to target_url, flash: { notice: I18n.t('delayed_job_admin.destroy_job.success') }
      rescue StandardError => e
        Rails.logger.warn("#{e.message}:\n\n #{e.backtrace}")
        redirect_to target_url, flash: { error: I18n.t('delayed_job_admin.destroy_job.failure') }
      end
    end
  end
end
