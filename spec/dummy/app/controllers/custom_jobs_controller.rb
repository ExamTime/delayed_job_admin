class CustomJobsController < ApplicationController
  def new
  end

  def create
    DummyModel.create(name: params[:name]).delay.method_to_queue(params[:message])
    redirect_to delayed_job_admin_engine.jobs_url
  end
end
