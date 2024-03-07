require "rails_helper"

RSpec.describe RfpIdeaSubmissionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/rfp_idea_submissions").to route_to("rfp_idea_submissions#index")
    end

    it "routes to #new" do
      expect(get: "/rfp_idea_submissions/new").to route_to("rfp_idea_submissions#new")
    end

    it "routes to #show" do
      expect(get: "/rfp_idea_submissions/1").to route_to("rfp_idea_submissions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/rfp_idea_submissions/1/edit").to route_to("rfp_idea_submissions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/rfp_idea_submissions").to route_to("rfp_idea_submissions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/rfp_idea_submissions/1").to route_to("rfp_idea_submissions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/rfp_idea_submissions/1").to route_to("rfp_idea_submissions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/rfp_idea_submissions/1").to route_to("rfp_idea_submissions#destroy", id: "1")
    end
  end
end
