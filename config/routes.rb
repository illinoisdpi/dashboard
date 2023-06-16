Rails.application.routes.draw do
  authenticate :user, ->(user) { user.has_role? :admin } do
    mount RailsAdmin::Engine, at: "admin", as: "rails_admin"
  end

  authenticate :user, ->(user) { [:admin, :instructor].any? { |role| user.has_role? role } } do
    mount Blazer::Engine, at: "blazer"
  end

  devise_for :users

  resources :impressions
  resources :cohorts do
    resources :canvas_gradebook_snapshots
    resources :enrollments
    # TODO: add module: :cohort
    resources :impressions
    resources :piazza_activity_reports
    resources :profiles do
      member do
        get 'snapshot'
      end
    end
  end

  root "dashboard#index"
end
