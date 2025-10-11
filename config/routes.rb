Rails.application.routes.draw do
  # ログイン時のルートパス
  authenticated :user do
    root to: "daily_records#new", as: "user_authenticated_root"
  end
  # 非ログイン時のルートパス
  root to: "pages#top"

  get "/terms_of_service" => "pages#terms_of_service"
  get "/privacy_policy" => "pages#privacy_policy"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  resources :daily_records, only: %i[new create destroy]
  resources :care_relations, only: %i[index new create show destroy]
  resources :charts, only: %i[index]
  resource :mypage, only: %i[show]
  resource :invitation, only: %i[new create]
  resources :users, only: [] do
    resource :chart, only: %i[show] do
      get "data", on: :member
    end
    resources :daily_records, only: %i[index show edit update]
  end
  resources :action_items, only: %i[index]
  resources :contacts, only: %i[new create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
