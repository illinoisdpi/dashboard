require "rails_helper"

RSpec.describe PiazzaActivityReportsController do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/piazza_activity_reports").to route_to("piazza_activity_reports#index")
    end

    it "routes to #new" do
      expect(get: "/piazza_activity_reports/new").to route_to("piazza_activity_reports#new")
    end

    it "routes to #show" do
      expect(get: "/piazza_activity_reports/1").to route_to("piazza_activity_reports#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/piazza_activity_reports/1/edit").to route_to("piazza_activity_reports#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/piazza_activity_reports").to route_to("piazza_activity_reports#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/piazza_activity_reports/1").to route_to("piazza_activity_reports#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/piazza_activity_reports/1").to route_to("piazza_activity_reports#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/piazza_activity_reports/1").to route_to("piazza_activity_reports#destroy", id: "1")
    end
  end
end
