# Preview all emails at http://localhost:3000/rails/mailers/task_mailer
class TaskMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/task_mailer/rfp_submission_created
  def rfp_submission_created
    TaskMailer.rfp_submission_created
  end

end
