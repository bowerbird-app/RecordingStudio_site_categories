Rails.application.routes.draw do
  devise_for :users

  get "/recording_studio", to: redirect("/"), as: nil
  mount RecordingStudio::Engine, at: "/recording_studio"
  mount RecordingStudioRootSwitchable::Engine, at: "/recording_studio_root_switchable"
  mount RecordingStudioSiteCategories::Engine, at: "/recording_studio_site_categories"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :pages, only: %i[index new create edit update destroy]

  root "home#index"
end
