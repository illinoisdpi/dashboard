require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  # Define Devise routes globally
  devise_for :users, path: "", path_names: {sign_in: "sign_in", sign_out: "sign_out"}

  # Routes for the dashboard subdomain with authentication
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

    resources :cohorts do
      member do
        get "canvas_highest_position_submission_count"
        get "canvas_point_total_most_recent"
        get "canvas_cumulative_points"
      end
      resources :canvas_gradebook_snapshots
      resources :enrollments, module: :cohort do
        member do
          get "overview"
          get "snapshot"
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

  # Routes for the news subdomain (publicly accessible)
  constraints subdomain: "news" do
    root "news#index", as: "news_root"
    get "/rss", to: "news#rss"
  end

  # Routes for the RFP subdomain (publicly accessible)
  constraints subdomain: "rfp" do
    root "rfp#index", as: "rfp_root"
    resources :rfp_idea_submissions, only: [:new, :create]
  end

  # Routes for the shoutouts subdomain with authentication
  constraints subdomain: "shoutouts" do
    authenticate :user do
      root "shoutouts#index", as: "shoutouts_root"
      resources :shoutouts do
        resources :shoutout_subjects, only: [:create, :destroy]
      end
    end
  end
end
