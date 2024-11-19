  constraints subdomain: "outcomes" do
    root "outcomes#index", as: "outcomes_root"
    resources :placements
  end