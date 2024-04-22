class RfpIdeaSubmissionsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.rfp_idea_submissions_mailer.confimration.subject
  #
  def confimration
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
