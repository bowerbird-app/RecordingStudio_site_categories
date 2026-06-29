# frozen_string_literal: true

RecordingStudioSiteCategories::Engine.routes.draw do
  root "categories#index"
  resources :categories, only: :index
end
