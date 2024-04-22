require "rails_helper"

RSpec.describe RfpMailer, type: :mailer do
  describe "new_rfp_idea_submitted" do
    let(:mail) { RfpMailer.new_rfp_idea_submitted }

    it "renders the headers" do
      expect(mail.subject).to eq("New rfp idea submitted")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
