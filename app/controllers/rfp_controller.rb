class RfpController < ApplicationController
  layout "rfp"
  skip_before_action :authenticate_user!
  skip_after_action :verify_policy_scoped
  before_action { authorize(:rfp) }

  def index
  end
end
