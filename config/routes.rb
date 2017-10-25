Rails.application.routes.draw do
  resources :stories do
    resources :tasks
  end
end
