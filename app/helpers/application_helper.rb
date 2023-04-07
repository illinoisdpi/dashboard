module ApplicationHelper
  def rating_class(rating)
    case rating
    when :proficient
      "success"
    when :capable
      "info"
    when :emerging
      "primary"
    else
      "primary"
    end
  end
end
