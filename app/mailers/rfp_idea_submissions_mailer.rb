class RfpIdeaSubmissionsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.rfp_idea_submissions_mailer.confimration.subject
  #
  def confirmation
    @greeting = "Hi"

    mail(to: "amompremier@gmail.com", subject: "RFP Idea Submission Received")
  end
end
