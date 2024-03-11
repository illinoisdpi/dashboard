require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  constraints subdomain: "dashboard" do
    authenticate :user, ->(user) { ApplicationPolicy.new(user, nil).admin_panel_accessible? } do
      mount RailsAdmin::Engine, at: "admin", as: "rails_admin"
    end

    authenticate :user, ->(user) { ApplicationPolicy.new(user, nil).sidekiq_panel_accessible? } do
      mount Sidekiq::Web => "/sidekiq"
    end

    authenticate :user, ->(user) { ApplicationPolicy.new(user, nil).blazer_panel_accessible? } do
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
      resources :impressions, module: :cohort do
        collection do
          get :search
        end
      end
      resources :piazza_activity_reports
    end

    resources :impressions do
      get :search, to: "impressions#search", on: :collection
    end

    root "dashboard#index", as: "dashboard_root"
  end

  constraints subdomain: "news" do
    root "news#index", as: "news_root"
    get "/rss", to: "news#rss"
  end

  constraints subdomain: "rfp" do
    root "rfp#index", as: "rfp_root"
    resources :rfp_idea_submissions, only: [:new, :create]
  end
end
