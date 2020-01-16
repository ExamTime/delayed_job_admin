DelayedJobAdmin::Engine.routes.draw do
  resources :jobs, only: [ :index, :destroy ] do
    member do
      get :job_status
    end
    collection do
      get '/:job_ids/statuses', to: 'jobs#job_statuses', as: :job_statuses
    end
  end

  resources :archived_jobs, only: [ :index ]

  root to: 'jobs#index'
end
