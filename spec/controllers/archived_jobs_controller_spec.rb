require 'spec_helper'

describe DelayedJobAdmin::ArchivedJobsController, type: :controller do
  before :all do
    DelayedJobAdmin::ArchivedJob.delete_all
  end

  before :each do
    @routes = DelayedJobAdmin::Engine.routes
  end

  it "should be defined" do
    expect(DelayedJobAdmin::ArchivedJobsController).to be_a Class
  end

  it "should be a subclass of ActionController::Base" do
    expect(DelayedJobAdmin::ArchivedJobsController.ancestors).to include ActionController::Base
  end

  it "should be a subclass of DelayedJobAdmin::ApplicationController" do
    expect(DelayedJobAdmin::ArchivedJobsController.ancestors).to include DelayedJobAdmin::ApplicationController
  end

  describe "action" do
    before :each do
      @job = DummyModel.create(name: 'Model in queue').delay.method_to_queue('in queue')
      @archived_job = DelayedJobAdmin::ArchivedJob.create(job: @job, archived_at: DateTime.now, archive_note: 'Archived')
    end

    describe "GET #index" do
      before :each do
        allow(DelayedJobAdmin).to receive(:pagination_excluding_queues).and_return(['B'])
        @queued_model_queue_a = DummyModel.create(name: 'Model in queue A')
        @queued_model_queue_b = DummyModel.create(name: 'Model in queue B')
        @job_queue_a = @queued_model_queue_a.delay(queue: 'A').method_to_queue('in queue A')
        @job_queue_b = @queued_model_queue_b.delay(queue: 'B').method_to_queue('in queue B')
        @archived_job_queue_a = DelayedJobAdmin::ArchivedJob.create(job: @job_queue_a, archived_at: DateTime.now, archive_note: 'Archived')
        @archived_job_queue_b = DelayedJobAdmin::ArchivedJob.create(job: @job_queue_b, archived_at: DateTime.now, archive_note: 'Archived')
      end

      it "should render the :index template" do
        get :index
        expect(response).to render_template :index
      end

      it "should assign a list of all jobs currently archived" do
        unarchived_job = DummyModel.create(name: 'Model not in queue').delay.method_to_queue('not in queue')
        get :index
        archived_jobs = assigns(:jobs)
        archived_ids = archived_jobs.map(&:id)
        expect(archived_ids).to include @job.id
        expect(archived_ids).not_to include unarchived_job.id
      end

      it "should list archived jobs not assigned to any specific queue" do
        get :index
        archived_jobs = assigns(:jobs)
        archived_ids = archived_jobs.map(&:id)
        expect(archived_ids).to include @job.id
      end

      it "should list jobs in non-blacklisted queues" do
        get :index
        archived_jobs = assigns(:jobs)
        archived_ids = archived_jobs.map(&:id)
        expect(archived_ids).to include @job_queue_a.id
      end

      it "should not list jobs in blacklisted queues" do
        get :index
        archived_jobs = assigns(:jobs)
        archived_ids = archived_jobs.map(&:id)
        expect(archived_ids).not_to include @job_queue_b.id
      end
    end

  end
end
