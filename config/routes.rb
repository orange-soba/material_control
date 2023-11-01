Rails.application.routes.draw do
  devise_for :users
  root "static_pages#home"
  resources :users, only: :show
  resource :parts, only: [:new, :create]
  resources :materials, only: [:new, :create]
end
