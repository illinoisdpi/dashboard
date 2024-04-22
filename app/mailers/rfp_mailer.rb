class RfpMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.rfp_mailer.new_rfp_idea_submitted.subject
  #
  def new_rfp_idea_submitted
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
