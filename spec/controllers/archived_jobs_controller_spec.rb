require 'spec_helper'

describe DelayedJobAdmin::ArchivedJobsController do
  before :all do
    DelayedJobAdmin::ArchivedJob.delete_all
  end

  it "should be defined" do
    DelayedJobAdmin::ArchivedJobsController.should be_a Class
  end

  it "should be a subclass of ActionController::Base" do
    DelayedJobAdmin::ArchivedJobsController.ancestors.should include ActionController::Base
  end

  it "should be a subclass of DelayedJobAdmin::ApplicationController" do
    DelayedJobAdmin::ArchivedJobsController.ancestors.should include DelayedJobAdmin::ApplicationController
  end

  describe "action" do
    before :each do
      @job = DummyModel.create(name: 'Model in queue').delay.method_to_queue('in queue')
      @archived_job = DelayedJobAdmin::ArchivedJob.create(job: @job, archived_at: DateTime.now, archive_note: 'Archived')
    end

    describe "GET #index" do
      before :each do
        DelayedJobAdmin.stub(:pagination_excluding_queues).and_return(['B'])
        @queued_model_queue_a = DummyModel.create(name: 'Model in queue A')
        @queued_model_queue_b = DummyModel.create(name: 'Model in queue B')
        @job_queue_a = @queued_model_queue_a.delay(queue: 'A').method_to_queue('in queue A')
        @job_queue_b = @queued_model_queue_b.delay(queue: 'B').method_to_queue('in queue B')
        @archived_job_queue_a = DelayedJobAdmin::ArchivedJob.create(job: @job_queue_a, archived_at: DateTime.now, archive_note: 'Archived')
        @archived_job_queue_b = DelayedJobAdmin::ArchivedJob.create(job: @job_queue_b, archived_at: DateTime.now, archive_note: 'Archived')
      end

      it "should render the :index template" do
        get :index, use_route: :delayed_job_admin
        response.should render_template :index
      end

      it "should assign a list of all jobs currently archived" do
        unarchived_job = DummyModel.create(name: 'Model not in queue').delay.method_to_queue('not in queue')
        get :index, use_route: :delayed_job_admin
        archived_jobs = assigns(:jobs)
        archived_ids = archived_jobs.map(&:id)
        archived_ids.should include @job.id
        archived_ids.should_not include unarchived_job.id
      end

      it "should list archived jobs not assigned to any specific queue" do
        get :index, use_route: :delayed_job_admin
        archived_jobs = assigns(:jobs)
        archived_ids = archived_jobs.map(&:id)
        archived_ids.should include @job.id
      end

      it "should list jobs in non-blacklisted queues" do
        get :index, use_route: :delayed_job_admin
        archived_jobs = assigns(:jobs)
        archived_ids = archived_jobs.map(&:id)
        archived_ids.should include @job_queue_a.id
      end

      it "should not list jobs in blacklisted queues" do
        get :index, use_route: :delayed_job_admin
        archived_jobs = assigns(:jobs)
        archived_ids = archived_jobs.map(&:id)
        archived_ids.should_not include @job_queue_b.id
      end
    end

  end
end
