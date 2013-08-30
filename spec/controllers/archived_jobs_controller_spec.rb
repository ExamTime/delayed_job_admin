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
    end

  end
end
