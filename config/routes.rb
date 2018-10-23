Rails.application.routes.draw do

  
  
  #static_pages
  root 'static_pages#home'
  get '/about', 	    to: 'static_pages#about'
  get '/help', 		    to: 'static_pages#help'
  get '/contact', 	  to: 'static_pages#contact'
  #users
  get '/signup',      to: 'users#new'
  #get '/unsubscribe', to: 'users#unsubscribe'
  resources :users do
    member do
      get :following, :followers, :unsubscribe, :chat, :chat_index
    end
    collection do
      post :index_search
    end
  end
  #sessions
  get    '/login',       to: 'sessions#new'
  post   '/login',       to: 'sessions#create'
  delete '/logout',      to: 'sessions#destroy'
  #accout_activations
  resources :account_activations, only: [:edit]
  #password_resets
  resources :password_resets,     only: [:new, :create, :edit, :update]
  #microposts
  resources :microposts, only: [:show, :new, :create, :destroy, :index] do
    collection do
      get  :input
      post :search
      post :index_search
    end
  end
  #relationships
  resources :relationships, only: [:create, :destroy]
  #likes
  resources :likes, only: [:create, :destroy]

  mount ActionCable.server => '/cable'
end
