DelayedJobAdmin::Engine.routes.draw do
  resources :jobs, only: [ :index, :destroy ] do
    collection do
      get '/:job_ids/statuses' => 'DelayedJobAdmin::Jobs#job_statuses', as: :statuses_delayed_jobs_path
    end
  end

  resources :archived_jobs, only: [ :index ]

  root to: 'jobs#index'
end
