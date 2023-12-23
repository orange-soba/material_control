Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  root "static_pages#home"
  resources :users, only: :show
  resources :parts, only: [:new, :create, :show, :edit, :update, :destroy] do
    member do
      get 'calculate'
      patch 'stock_update'
    end
    resource :parts_relations, only: [:new, :create, :destroy, :update]
    resource :need_materials, only: [:new, :create, :destroy, :update]
  end
  resources :materials, except: :show do
    member do
      patch 'stock_update'
    end
  end
end
