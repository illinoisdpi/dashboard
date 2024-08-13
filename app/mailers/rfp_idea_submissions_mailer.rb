class RfpIdeaSubmissionsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.rfp_idea_submissions_mailer.confimration.subject
  #
  def confirmation(rfp_idea_submission)
    @rfp_idea_submission = rfp_idea_submission

    mail(
      to: @rfp_idea_submission.contact_email,
      subject: "Your RFP Idea Submission Received"
    )
  end
end
