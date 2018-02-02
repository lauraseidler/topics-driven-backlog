Rails.application.routes.draw do
  get 'frontend/index'

  root to: 'frontend#index'

  post 'get-token', to: 'authentication#authenticate'

  resources :stories, only: [:show, :update, :destroy] do
    resources :tasks, only: [:index, :create, :show, :update, :destroy]
  end
  resources :tasks, only: [:index]

  resources :courses, only: [:index, :create, :show, :update, :destroy] do
    post 'sprint-collection', to: 'sprints#create_collection'
    patch 'sprint-collection', to: 'sprints#update_collection'
    resources :sprints, only: [:create]
    resources :topics, only: [:create]
    resources :projects, only: [:index, :create]
  end


  resources :sprints, only: [:update, :destroy]
  resources :topics, only: [:update, :destroy]
  resources :projects, only: [:show, :update, :destroy] do
    post 'enrollments', to: 'projects#enroll_user'
    delete 'enrollment', to: 'projects#remove_enrollment'
    put 'sprint-planning-complete/:sprint_id', to: 'projects#complete_sprint'
    patch 'sprint-planning-complete/:sprint_id', to: 'projects#complete_sprint'
    resources :stories, only: [:index, :create]
  end
end
