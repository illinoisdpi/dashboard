require "rails_helper"

RSpec.describe ImpressionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/impressions").to route_to("impressions#index")
    end

    it "routes to #new" do
      expect(get: "/impressions/new").to route_to("impressions#new")
    end

    it "routes to #show" do
      expect(get: "/impressions/1").to route_to("impressions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/impressions/1/edit").to route_to("impressions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/impressions").to route_to("impressions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/impressions/1").to route_to("impressions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/impressions/1").to route_to("impressions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/impressions/1").to route_to("impressions#destroy", id: "1")
    end
  end
end
