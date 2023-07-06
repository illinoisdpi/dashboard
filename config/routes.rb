require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  constraints subdomain: "dashboard" do
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
      resources :enrollments, module: :cohort do
        member do
          get 'overview'
          get 'snapshot'
        end
      end
      resources :impressions, module: :cohort
      resources :piazza_activity_reports
    end
    resources :impressions

    root "dashboard#index", as: "dashboard_root"
  end

  constraints subdomain: "news" do
    root "news#index", as: "news_root"
    get "/rss", to: "news#rss"
  end
end
