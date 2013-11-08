DelayedJobAdmin::Engine.routes.draw do
  resources :jobs, only: [ :index, :destroy ] do
    member do
      get :job_status
    end
  end

  resources :archived_jobs, only: [ :index ]

  root to: 'jobs#index'
end
