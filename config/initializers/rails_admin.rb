RailsAdmin.config do |config|
  config.asset_source = :sprockets

  config.navigation_static_links = {
    "Home" => "/"
  }

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  config.authorize_with :pundit

  ## == PaperTrail ==
  config.audit_with :paper_trail, "User", "PaperTrail::Version" # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  config.show_gravatar = false

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit do
      except [ "PiazzaActivityReport", "PiazzaActivityBreakdown" ]
    end
    delete do
      except [ "PiazzaActivityBreakdown" ]
    end
    show_in_app

    ## With an audit adapter, you can add:
    history_index
    history_show
  end
end
