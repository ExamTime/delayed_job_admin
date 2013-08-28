DelayedJobAdmin::Engine.routes.draw do
  resources :jobs, only: [ :index ] do
    member do
      get :status
    end
  end
  root to: 'jobs#index'
end
