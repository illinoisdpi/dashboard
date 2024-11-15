  constraints subdomain: "rfp" do
    root "rfp#index", as: "rfp_root"
    resources :rfp_idea_submissions, only: [:new, :create]
  end
