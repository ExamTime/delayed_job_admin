Rails.application.routes.draw do

  #mount DelayedJobAdmin::Engine => "/delayed_job_admin", :as => "delayed_job_admin_engine"
  mount DelayedJobAdmin::Engine => "/delayed_job_admin"

  resources :custom_jobs, only: [:new, :create]

  root to: "delayed_job_admin/jobs#index"
end
