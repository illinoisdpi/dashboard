constraints subdomain: "dashboard" do
  draw(:admin)

  devise_for :users, controllers: { registrations: "registrations" }

  resources :users, only: [] do
    collection do
      get :search_by_name
    end
  end

  resources :cohorts do
    member do
      get "canvas_highest_position_submission_count"
      get "canvas_point_total_most_recent"
      get "canvas_cumulative_points"
    end
    resources :canvas_gradebook_snapshots
    resources :discord_channels, only: %i[index show] do
      resources :recurring_messages, only: %i[ create edit update destroy]
    end
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
