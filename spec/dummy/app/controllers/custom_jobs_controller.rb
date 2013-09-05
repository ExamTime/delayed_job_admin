class CustomJobsController < ApplicationController
  def new
  end

  def create
    name = params.fetch(:name)
    delay = params.fetch(:delay).to_i
    DummyModel.create(name: name, delay_in_seconds: delay).delay.method_to_queue(params[:message])
    redirect_to delayed_job_admin.jobs_url
  end
end
