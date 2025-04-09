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

  namespace :dashboard do
    get :survey_status_count
    get :user_count
    get :survey_growth
    get :completion_summary
    get :recent_activities
    get :data_count
  end

  resources :surveys do
    get "kpis/average_scores_per_category", to: "survey_kpis#average_scores_per_category"
    get "kpis/completion_rate", to: "survey_kpis#completion_rate"
    get "kpis/engagement_index", to: "survey_kpis#engagement_index"
    get "kpis/performance_brackets", to: "survey_kpis#performance_brackets"
  end

  resources :users, only: [ :index, :create ]
end
