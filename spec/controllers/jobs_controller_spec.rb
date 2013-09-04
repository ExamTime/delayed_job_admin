require 'spec_helper'

describe DelayedJobAdmin::JobsController do
  before :all do
    Delayed::Job.delete_all
  end

  it "should be defined" do
    DelayedJobAdmin::JobsController.should be_a Class
  end

  it "should be a subclass of ActionController::Base" do
    DelayedJobAdmin::JobsController.ancestors.should include ActionController::Base
  end

  it "should be a subclass of DelayedJobAdmin::ApplicationController" do
    DelayedJobAdmin::JobsController.ancestors.should include DelayedJobAdmin::ApplicationController
  end

  describe "action" do
    before :each do
      @queued_model = DummyModel.create(name: 'Model in queue')
      @job = @queued_model.delay.method_to_queue('in queue')
    end

    describe "GET #index" do
      it "should render the :index template" do
        get :index, use_route: :delayed_job_admin
        response.should render_template :index
      end

      it "should assign a list of all jobs currently in the queue" do
        unqueued_model = DummyModel.create(name: 'Model not in queue')
        unqueued_model.method_to_queue('not in queue')
        get :index, use_route: :delayed_job_admin
        queued_jobs = assigns(:jobs)
        queued_models = queued_jobs.map(&:payload_object).map(&:object)
        queued_models.should include @queued_model
        queued_models.should_not include unqueued_model
      end
    end

    describe "DELETE #destroy" do
      before :all do
        @cached_handlers = DelayedJobAdmin.destroy_handlers
        DelayedJobAdmin.destroy_handlers = [ DummyHandler ]
      end

      after :all do
        DelayedJobAdmin.destroy_handlers = @cached_handlers
      end

      it "should invoke the configured destroy handler" do
        mock_handler = double('mock_handler')
        DummyHandler.should_receive(:new).with(@job).once.and_return(mock_handler)
        mock_handler.should_receive(:handle).once
        delete :destroy, id: @job, use_route: :delayed_job_admin
      end

      context 'handlers process successfully' do
        it "should set a :notice flash message on delete" do
          delete :destroy, id: @job, use_route: :delayed_job_admin
          flash[:notice].should == I18n.t('delayed_job_admin.destroy_job.success')
        end

        it "should redirect to the DelayedJobAdmin::JobsController#index action" do
          delete :destroy, id: @job, use_route: :delayed_job_admin
          response.should redirect_to jobs_path
        end
      end

      context 'handlers throw an exception' do
        before :each do
          DummyHandler.any_instance.stub(:handle) { raise StandardError }
        end

        it "should set an :error flash message" do
          delete :destroy, id: @job, use_route: :delayed_job_admin
          flash[:error].should == I18n.t('delayed_job_admin.destroy_job.failure')
        end

        it "should redirect to the DelayedJobAdmin::JobsController#index action" do
          delete :destroy, id: @job, use_route: :delayed_job_admin
          response.should redirect_to jobs_path
        end
      end
    end

    describe "GET #status" do
      describe "when job is in the queue" do
        describe "and the job has not yet been processed" do
          it "should return json indicating job is pending" do
            get :status, id: @job.id, use_route: :delayed_job_admin
            JSON.parse(response.body)['status'].should == 'pending'
          end
        end

        describe "and the job has errored during processing" do
          before :each do
            @job.fail!
          end

          it "should return json indicating the job has failed" do
            get :status, id: @job.id, use_route: :delayed_job_admin
            JSON.parse(response.body)['status'].should == 'failing'
          end
        end
      end

      describe "when job is not in the queue" do
        it "should return json indicating the job could not be found" do
          get :status, id: 99, use_route: :delayed_job_admin
          JSON.parse(response.body)['status'].should == 'none'
        end
      end
    end
  end
end
