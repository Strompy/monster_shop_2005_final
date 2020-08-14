Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, only: [:show, :index, :edit, :update, :destroy] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  post "/cart/:item_id", to: "cart#add_item"
  patch "/cart/:item_id", to: "cart#update_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  resources :orders, only: [:new, :create, :show, :destroy, :update]

  scope :register do
    get "/", to: 'users#new'
    post "/", to: 'users#create'
  end

  get "/login", to: 'sessions#new'
  post "/login", to: 'sessions#create'
  delete "/logout", to: 'sessions#destroy'


  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile', to: 'users#update'
  get '/profile/password_edit', to: 'users#edit_password' #passwordscontroller?
  patch '/profile/password_update', to: 'users#update_password'
  get '/profile/orders', to: 'user_orders#index'
  get '/profile/orders/:order_id', to: 'user_orders#show'

  namespace :admin do
    resources :merchants, only: [:show, :index, :destroy, :update] do
      resources :items, only: [:index, :new, :create, :update, :edit]
    end
    resources :users, only: [:index, :show]
    resources :orders, only: [:show]
    resources :items, only: [:destroy] do
      patch "/toggle", to: 'toggle_items#update'
    end
    resources :dashboard, only: [:index]
    patch '/dashboard', to: 'dashboard#update'
  end

  namespace :merchant do
    resources :dashboard, only: [:index]
    resources :orders, only: [:show]
    resources :items do
      patch "/toggle", to: 'toggle_items#update'
    end
    patch "/items/:item_order_id/fulfill", to: "fulfill#update"
    resources :discounts, except: [:show]
  end
end
