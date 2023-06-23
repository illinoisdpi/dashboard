require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.has_role? :admin } do
    mount RailsAdmin::Engine, at: "admin", as: "rails_admin"
    mount Sidekiq::Web => "/sidekiq"
  end

  authenticate :user, ->(user) { [:admin, :instructor].any? { |role| user.has_role? role } } do
    mount Blazer::Engine, at: "blazer"
  end

  devise_for :users

  resources :cohorts do
    resources :canvas_gradebook_snapshots
    resources :enrollments
    resources :impressions, module: :cohort
    resources :piazza_activity_reports
    resources :profiles do
      member do
        get 'snapshot'
      end
    end
  end
  resources :devto_articles, only: [:index]
  resources :feed, only: [:index]
  resources :impressions

  root "dashboard#index"
end
