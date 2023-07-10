class RunChecksJob < ApplicationJob
  queue_as :blazer

  def perform(schedule)
    Blazer.run_checks(schedule:)
  end
end
