# Preview all emails at http://localhost:3000/rails/mailers/rfp_mailer
class RfpMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/rfp_mailer/new_rfp_idea_submitted
  def new_rfp_idea_submitted
    RfpMailer.new_rfp_idea_submitted
  end

end
