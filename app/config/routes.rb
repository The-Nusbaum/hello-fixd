Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  root to: 'feeds#index'
  get 'feed(/:user_id)', to: 'feeds#index'

  resources :posts, only: %w[create update show destroy]
  resources :comments, only: %w[create update show destroy]
  resources :ratings, only: %w[create update show destroy]
  resources :api_keys, path: 'api-keys', only: %i[index create destroy] 
end
