constraints subdomain: "news" do
  get "/rss", to: "news#rss"

  root "news#index", as: "news_root"
end
