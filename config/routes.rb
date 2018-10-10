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
      get :following, :followers, :unsubscribe
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
end
