Rails.application.routes.draw do
  get 'frontend/index'

  root to: 'frontend#index'

  resources :stories, only: [:show, :update, :destroy] do
    resources :tasks, only: [:index, :create, :show, :update, :destroy]
  end
  resources :tasks, only: [:index]

  resources :courses, only: [:index, :create, :show, :update, :destroy] do
    post 'sprint-collection', to: 'sprints#create_collection'
    resources :sprints, only: [:create]
    resources :projects, only: [:index, :create]
  end
    resources :sprints, only: [:update, :destroy]
    resources :projects, only: [:show, :update, :destroy] do
      resources :stories, only: [:index, :create]
    end

end
