# == Schema Information
#
# Table name: recurring_messages
#
#  id              :uuid             not null, primary key
#  days_of_week    :text             default([]), is an Array
#  frequency       :string           default("weekly"), not null
#  message_content :text
#  scheduled_time  :time
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  channel_id      :string
#  cohort_id       :uuid
#  job_id          :string
#
# Indexes
#
#  index_recurring_messages_on_cohort_id  (cohort_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#
class RecurringMessage < ApplicationRecord
  DAYS = %w[monday tuesday wednesday thursday friday saturday sunday].freeze
  FREQUENCIES = %w[weekly biweekly monthly].freeze

  belongs_to :cohort

  validates :message_content, presence: true
  validates :scheduled_time, presence: true
  validates :frequency, inclusion: { in: FREQUENCIES }
  validates :days_of_week, presence: true, inclusion: { in: DAYS, message: "%{value} is not a valid day" }, length: { minimum: 1 }

  def schedule_discord_message
    cancel_previous_job
    next_occurrence = calculate_next_occurrence
    return unless next_occurrence

    job = DiscordMessageJob
          .set(wait_until: next_occurrence)
          .perform_later(id)
    update_column(:job_id, job.provider_job_id) if job.respond_to?(:provider_job_id)
  end

  def cancel_previous_job
    return if job_id.blank?

    scheduled_set = Sidekiq::ScheduledSet.new
    if (job = scheduled_set.find_job(job_id))
      job.delete
    end
  end

  def calculate_next_occurrence
    debugger
    now = Time.current
    target_seconds = Time.parse(scheduled_time.to_s).seconds_since_midnight

    weekdays = days_of_week.map do |day|
      Date::DAYNAMES.index(day.capitalize)
    end.compact

    candidates = weekdays.map do |weekday|
      days_ahead = (weekday - now.wday) % 7
      candidate = now.beginning_of_day + days_ahead.days + target_seconds.seconds
      candidate <= now ? candidate + 1.week : candidate
    end

    candidates.min
  end
end
