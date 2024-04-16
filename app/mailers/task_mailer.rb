class TaskMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.task_mailer.rfp_submission_created.subject
  #
  def rfp_submission_created
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
