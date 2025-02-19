class RecurringMessageService
  def self.calculate_initial_run(message)
    now = Time.current.in_time_zone(message.cohort.timezone)
    target_time = message.scheduled_time

    next_day = message.days_of_week.min_by do |day|
      day_number = RecurringMessage::DAYS.index(day)
      next_occurrence(now, day_number, target_time)
    end

    next_occurrence(now, RecurringMessage::DAYS.index(next_day), target_time)
  end

  def self.next_occurrence(base_time, day_index, target_time)
    current_wday = base_time.wday
    days_ahead = (day_index - current_wday) % 7
    candidate = base_time + days_ahead.days

    candidate = candidate.change(
      hour: target_time.hour,
      min: target_time.min,
      sec: 0
    )

    candidate > base_time ? candidate : candidate + 1.week
  end

  def self.calculate_next_run(message)
    last_run = message.next_run_at.in_time_zone(message.cohort.timezone)
    target_time = message.scheduled_time

    next_day = message.days_of_week.min_by do |day|
      day_number = RecurringMessage::DAYS.index(day)
      next_occurrence(last_run, day_number, target_time)
    end

    next_occurrence(last_run, RecurringMessage::DAYS.index(next_day), target_time)
  end
end
