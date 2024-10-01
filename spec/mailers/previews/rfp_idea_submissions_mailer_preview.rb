# Preview all emails at http://localhost:3000/rails/mailers/rfp_idea_submissions_mailer
class RfpIdeaSubmissionsMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/rfp_idea_submissions_mailer/confirmation
  def confirmation
    RfpIdeaSubmissionsMailer.confirmation(RfpIdeaSubmission.last)
  end
end
