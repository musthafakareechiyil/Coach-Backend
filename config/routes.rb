Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  post "/login", to: "sessions#login"

  resources :surveys do
    resources :responses, only: [ :create, :index ]
  end

  resources :rating_scales
  resources :questions
  resources :categories
  resources :surveys
end
