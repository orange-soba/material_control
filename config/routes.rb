Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  root "static_pages#home"
  resources :users, only: :show
  resources :parts, only: [:new, :create, :show] do
    resource :parts_relations, only: [:new, :create]
    resource :need_materials, only: [:new, :create]
    member do
      get 'calculate'
    end
  end
  resources :materials, except: :show do
    member do
      patch 'stock_update'
    end
  end
end
