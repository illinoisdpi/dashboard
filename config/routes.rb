Rails.application.routes.draw do
  devise_for :users
  mount Blazer::Engine, at: "blazer"
  
  root "cohorts#index"

  resources :cohorts do
    resources :enrollments
    resources :piazza_activity_reports
  end
end
