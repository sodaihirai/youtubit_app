Rails.application.routes.draw do

  #static_pages
  root 'static_pages#home'
  get '/about', 	  to: 'static_pages#about'
  get '/help', 		  to: 'static_pages#help'
  get '/contact', 	  to: 'static_pages#contact'
  #users
  get '/signup',      to: 'users#new'
  get '/unsubscribe', to: 'users#unsubscribe'
  resources :users
end
