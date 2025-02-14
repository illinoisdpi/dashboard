constraints subdomain: "dashboard" do
  draw(:admin)

  devise_for :users, controllers: { registrations: "registrations" }

  resources :users, only: [] do
    collection do
      get :search_by_name
    end
  end

  # TODO: refactor this block?
  resources :cohorts do
    member do
      get "canvas_highest_position_submission_count"
      get "canvas_point_total_most_recent"
      get "canvas_cumulative_points"
    end
    resources :canvas_gradebook_snapshots
    resources :enrollments do
      member do
        get "overview"
        get "snapshot"
      end
    end
    resources :piazza_activity_reports
  end

  resources :impressions do
    collection do
      get :search
    end
  end

  root "dashboard#index", as: "dashboard_root"
end
