Rails.application.routes.draw do
  get "static_pages/privacy_policy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :logs, only: %i[new]
  resource :uid_sessions, only: %i[create]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get "privacy_policy" => "static_pages#privacy_policy"
  get "terms_of_service" => "static_pages#terms_of_service"
  # Defines the root path route ("/")
  root "static_pages#privacy_policy"
end
