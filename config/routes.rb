DelayedJobAdmin::Engine.routes.draw do
  resources :jobs, only: [ :index, :destroy ] do
    member do
      get :status
    end
  end

  resources :archived_jobs, only: [ :index ]

  root to: 'jobs#index'
end
