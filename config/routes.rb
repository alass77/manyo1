Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :labels
  resources :sessions, only: [:new, :create,:destroy]
  resources :users, only: [:new, :create, :show, :edit, :update,:destroy]
  namespace :admin do
    resources :users
  end
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

end
