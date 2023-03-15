Rails.application.routes.draw do
  authenticate :user, ->(user) { user.has_role? :admin } do
    mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  end

  devise_for :users

  root "cohorts#index"

  resources :cohorts do
    resources :enrollments
    resources :piazza_activity_reports
  end
end
