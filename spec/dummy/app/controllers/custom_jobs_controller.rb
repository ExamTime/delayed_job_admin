class CustomJobsController < ApplicationController
  def new
  end

  def create
    name = params.fetch(:name)
    delay = params.fetch(:delay).to_i
    job = DummyModel.create(name: name, delay_in_seconds: delay).delay.method_to_queue(params[:message])
    respond_to do |format|
      format.html { redirect_to delayed_job_admin.jobs_url }
      format.json { render json: {job_id: job.id}.to_json }
    end
  end
end
