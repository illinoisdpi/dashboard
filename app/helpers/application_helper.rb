module ApplicationHelper
  def rating_class(rating)
    case rating
    when :excellent
      "success"
    when :proficient
      "info"
    when :emerging
      "primary"
    else
      "primary"
    end
  end
end
