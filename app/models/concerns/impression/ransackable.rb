module Impression::Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      [
        "content",
        "created_at"
      ]
    end

    def ransackable_associations(auth_object = nil)
      [
        "subject"
      ]
    end

    def ransackable_scopes(auth_object = nil)
      %i[filter_by_time_period]
    end

    def filter_by_time_period(time_period)
      case time_period
      when "last_week"
        last_week
      when "last_month"
        last_month
      else
        all
      end
    end
  end
end
