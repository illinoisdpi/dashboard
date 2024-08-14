require 'rails_helper'

RSpec.describe "ImpressionComments", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/impression_comments/create"
      expect(response).to have_http_status(:success)
    end
  end

end
