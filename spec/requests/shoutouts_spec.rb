require 'rails_helper'

RSpec.describe "Shoutouts", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/shoutouts/create"
      expect(response).to have_http_status(:success)
    end
  end

end
