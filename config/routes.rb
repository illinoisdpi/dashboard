Rails.application.routes.draw do
  devise_for :users

  root "cohorts#index"

  resources :piazza_activity_breakdowns
  resources :piazza_activity_downloads
  resources :enrollments
  resources :cohorts
end
