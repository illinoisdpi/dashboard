module Impression::Emojiable
  extend ActiveSupport::Concern

  included do
    validates :emoji, emoji: true
  end
  
  def summary
    "#{author} authored a #{emoji} impression of #{subject}"
  end
  
  def to_s
    summary
  end
  
  EMOJIS = {
    👍: "positive",
    👎: "negative",
    🙋: "asking questions",
    😇: "helping others",
    🥳: "growth",
    😬: "unprofessional",
    😠: "lashing out",
    🤩: "all star",
    😶: "lack communication",
    😑: "lack progress",
    ⏰: "time management"
  }.freeze
end
