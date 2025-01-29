require "sidekiq/web"
require "sidekiq/cron/web"

authenticate :user, ->(user) { ApplicationPolicy.new(user, nil).admin_panel_accessible? } do
  mount RailsAdmin::Engine, at: "admin", as: "rails_admin"
end

authenticate :user, ->(user) { ApplicationPolicy.new(user, nil).sidekiq_panel_accessible? } do
  mount Sidekiq::Web => "/sidekiq"
end

authenticate :user, ->(user) { ApplicationPolicy.new(user, nil).blazer_panel_accessible? } do
  mount Blazer::Engine, at: "blazer"
end
