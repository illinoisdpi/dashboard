module Impression::Emojiable
  extend ActiveSupport::Concern

  included do
    validates :emoji, emoji: true
  end
  
  def emoji_name
    Impression::EMOJIS[emoji.to_sym] || Emoji.find_by_unicode(emoji).name
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
    ⏰: "time management",
    ✅: "consistent",
    ❌: "inconsistent",
    🏁: "commited",
    🚷: "lack of follow-through",
    😎: "confident",
    🙈: "lack of confidence",
    💬: "good communication",
    🤐: "lacking communication",
    🤝: "collaboration",
    🚧: "conflict/lack of collaboration"
  }.freeze
end
