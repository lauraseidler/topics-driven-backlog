Rails.application.routes.draw do

  resources :stories, only: [:index, :create, :show, :update, :destroy] do
    resources :tasks, only: [:index, :create, :show, :update, :destroy]
  end
  resources :tasks, only: [:index]

end
