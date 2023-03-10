require "rails_helper"

RSpec.describe PiazzaActivityDownloadsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/piazza_activity_downloads").to route_to("piazza_activity_downloads#index")
    end

    it "routes to #new" do
      expect(get: "/piazza_activity_downloads/new").to route_to("piazza_activity_downloads#new")
    end

    it "routes to #show" do
      expect(get: "/piazza_activity_downloads/1").to route_to("piazza_activity_downloads#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/piazza_activity_downloads/1/edit").to route_to("piazza_activity_downloads#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/piazza_activity_downloads").to route_to("piazza_activity_downloads#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/piazza_activity_downloads/1").to route_to("piazza_activity_downloads#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/piazza_activity_downloads/1").to route_to("piazza_activity_downloads#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/piazza_activity_downloads/1").to route_to("piazza_activity_downloads#destroy", id: "1")
    end
  end
end
