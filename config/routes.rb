Rails.application.routes.draw do

  resources :stories do
    resources :tasks, only: [:index, :new, :create]
  end
  resources :tasks, only: [:index, :show, :edit, :update, :destroy]

end
