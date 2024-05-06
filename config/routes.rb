Rails.application.routes.draw do
  post 'auth/login', to: 'auth#login'
  post 'auth/signup', to: 'auth#signup'
  post 'auth/logout', to: 'auth#logout'
  post 'auth/email', to: 'auth#email'

  # Books routes
  resources :books do
    resources :reviews, only: [:index, :create, :show], shallow: true
  end

  # Users routes
  resources :users, only: [:show] do
    # Nested route to CRUD operations for books held by a user
    resources :books, controller: 'user_books', only: [:index, :create, :show, :update, :destroy]
  end

  # Elasticsearch
  get 'search', to: 'search#index'
  
  # Locale
  get 'i18n', to: 'locale#index'

  # get '/books/:file_name', to: 'books#book_cover_image_url', format: false
  # resources :books do
  #   resources :comments, only: [:create]
  #   resources :ratings, only: [:create]
  # end

  # resources :users do
  #   resources :books, controller: 'user_books', only: [:create, :index]
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
