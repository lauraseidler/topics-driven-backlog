Rails.application.routes.draw do
  get 'frontend/index'

  root to: 'frontend#index'

  resources :stories, only: [:index, :create, :show, :update, :destroy] do
    resources :tasks, only: [:index, :create, :show, :update, :destroy]
  end
  resources :tasks, only: [:index]

  resources :courses, only: [:index, :create, :show, :update, :destroy] do
    post 'sprint-collection', to: 'sprints#create_collection'
    resources :sprints, only: [:create]
  end
    resources :sprints, only: [:update, :destroy]

end
