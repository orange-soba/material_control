Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  root "static_pages#home"
  resources :users, only: :show
  resources :parts, only: [:new, :create, :show]
  resources :materials, only: [:new, :create]
end
