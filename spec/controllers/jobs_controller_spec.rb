require 'spec_helper'

describe DelayedJobAdmin::JobsController do
  before :all do
    Delayed::Job.delete_all
  end

  it "should be defined" do
    expect(DelayedJobAdmin::JobsController).to be_a Class
  end

  it "should be a subclass of ActionController::Base" do
    expect(DelayedJobAdmin::JobsController.ancestors).to include ActionController::Base
  end

  it "should be a subclass of DelayedJobAdmin::ApplicationController" do
    expect(DelayedJobAdmin::JobsController.ancestors).to include DelayedJobAdmin::ApplicationController
  end

  describe "action" do
    before :each do
      @queued_model = DummyModel.create(name: 'Model in queue')
      @job = @queued_model.delay.method_to_queue('in queue')
    end

    describe "GET #index" do
      before :each do
        allow(DelayedJobAdmin).to receive(:pagination_excluding_queues).and_return(['B'])
        @queued_model_queue_a = DummyModel.create(name: 'Model in queue A')
        @queued_model_queue_b = DummyModel.create(name: 'Model in queue B')
        @job_queue_a = @queued_model_queue_a.delay(queue: 'A').method_to_queue('in queue A')
        @job_queue_b = @queued_model_queue_b.delay(queue: 'B').method_to_queue('in queue B')
      end

      it "should render the :index template" do
        get :index, use_route: :delayed_job_admin
        expect(response).to render_template :index
      end

      it "should assign a list of all jobs currently in the queue" do
        unqueued_model = DummyModel.create(name: 'Model not in queue')
        unqueued_model.method_to_queue('not in queue')
        get :index, use_route: :delayed_job_admin
        queued_jobs = assigns(:jobs)
        queued_models = queued_jobs.map(&:payload_object).map(&:object)
        expect(queued_models).to include @queued_model
        expect(queued_models).not_to include unqueued_model
      end

      it "should list jobs not assigned to any specific queue" do
        get :index, use_route: :delayed_job_admin
        queued_jobs = assigns(:jobs)
        expect(queued_jobs).to include @job
      end

      it "should list jobs in non-blacklisted queues" do
        get :index, use_route: :delayed_job_admin
        queued_jobs = assigns(:jobs)
        expect(queued_jobs).to include @job_queue_a
      end

      it "should not list jobs in blacklisted queues" do
        get :index, use_route: :delayed_job_admin
        queued_jobs = assigns(:jobs)
        expect(queued_jobs).not_to include @job_queue_b
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
        expect(DummyHandler).to receive(:new).with(@job).once.and_return(mock_handler)
        expect(mock_handler).to receive(:handle).once
        delete :destroy, id: @job, use_route: :delayed_job_admin
      end

      context 'handlers process successfully' do
        it "should set a :notice flash message on delete" do
          delete :destroy, id: @job, use_route: :delayed_job_admin
          expect(flash[:notice]).to eq(I18n.t('delayed_job_admin.destroy_job.success'))
        end

        it "should redirect to the DelayedJobAdmin::JobsController#index action" do
          delete :destroy, id: @job, use_route: :delayed_job_admin
          expect(response).to redirect_to jobs_path
        end
      end

      context 'handlers throw an exception' do
        before :each do
          allow_any_instance_of(DummyHandler).to receive(:handle) { raise StandardError }
        end

        it "should set an :error flash message" do
          delete :destroy, id: @job, use_route: :delayed_job_admin
          expect(flash[:error]).to eq(I18n.t('delayed_job_admin.destroy_job.failure'))
        end

        it "should redirect to the DelayedJobAdmin::JobsController#index action" do
          delete :destroy, id: @job, use_route: :delayed_job_admin
          expect(response).to redirect_to jobs_path
        end
      end
    end

    describe "GET #job_status" do
      describe "when job is in the queue" do
        describe "and the job has not yet been processed" do
          it "should return json indicating job is pending" do
            get :job_statuses, job_ids: [@job.id], use_route: :delayed_job_admin
            expect(JSON.parse(response.body).first['status']).to eq('pending')
          end
        end

        describe "and the job has errored during processing" do
          context "when the job is still being attempted" do
            before :each do
              @job.last_error = 'Some dummy error message'
              @job.save!
            end

            it "should return json indicating the job is failing" do
              get :job_statuses, job_ids: [@job.id], use_route: :delayed_job_admin
              expect(JSON.parse(response.body).first['status']).to eq('failing')
            end
          end

          context "when the job has exhausted all attmepts" do
            before :each do
              @job.fail!
            end

            it "should return json indicating the job has failed" do
              get :job_statuses, job_ids: [@job.id], use_route: :delayed_job_admin
              expect(JSON.parse(response.body).first['status']).to eq('failed')
            end
          end
        end
      end

      describe "when job is not in the queue" do
        it "should return json indicating the job could not be found" do
          get :job_statuses, job_ids: [99], use_route: :delayed_job_admin
          expect(JSON.parse(response.body).first['status']).to eq('none')
        end
      end
    end
  end
end
