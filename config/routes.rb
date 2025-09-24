Rails.application.routes.draw do
  # ログイン時のルートパス
  authenticated :user do
    root to: "daily_records#new", as: "user_authenticated_root"
  end
  # 非ログイン時のルートパス
  root to: "pages#top"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :daily_records, only: %i[new create destroy]
  resources :charts, only: %i[index]
  resources :users, only: [] do
    resource :chart, only: %i[show]
    resources :daily_records, only: %i[index show edit update]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
