constraints subdomain: "rfp" do
  resources :rfp_idea_submissions, only: [ :new, :create ]

  root "rfp#index", as: "rfp_root"
end
