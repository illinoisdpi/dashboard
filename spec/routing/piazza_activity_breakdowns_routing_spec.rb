require "rails_helper"

RSpec.describe PiazzaActivityBreakdownsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/piazza_activity_breakdowns").to route_to("piazza_activity_breakdowns#index")
    end

    it "routes to #new" do
      expect(get: "/piazza_activity_breakdowns/new").to route_to("piazza_activity_breakdowns#new")
    end

    it "routes to #show" do
      expect(get: "/piazza_activity_breakdowns/1").to route_to("piazza_activity_breakdowns#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/piazza_activity_breakdowns/1/edit").to route_to("piazza_activity_breakdowns#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/piazza_activity_breakdowns").to route_to("piazza_activity_breakdowns#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/piazza_activity_breakdowns/1").to route_to("piazza_activity_breakdowns#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/piazza_activity_breakdowns/1").to route_to("piazza_activity_breakdowns#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/piazza_activity_breakdowns/1").to route_to("piazza_activity_breakdowns#destroy", id: "1")
    end
  end
end
