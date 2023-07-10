class SendFailingChecksJob < ApplicationJob
  queue_as :blazer

  def perform
    Blazer.send_failing_checks
  end
end
