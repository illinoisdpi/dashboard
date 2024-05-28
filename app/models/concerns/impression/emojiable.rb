module Impression::Emojiable
  extend ActiveSupport::Concern

  included do
    validates :emoji, emoji: true
  end

  def emoji_name
    Impression::EMOJIS[emoji.to_sym] || Emoji.find_by_unicode(emoji).name
  end

  EMOJIS = {
    🧥: "workplace appearance",
    🕴️: "workplace culture and policy",
    🙌: "follow-through",
    💯: "quality of work",
    ▶️: "taking initiative",
    🗣️: "communication skills",
    🫡: "response to supervision",
    🙏 : "teamwork",
    🛜: "networking",
    🤔: "problem solving",
    💪: "resilience",
    🪞: "self-awareness",
    🤗: "attitude",
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
    🏁: "committed",
    🚷: "lack of follow-through",
    😎: "confident",
    🙈: "lack of confidence",
    💬: "good communication",
    🤐: "lacking communication",
    🤝: "collaboration",
    🚧: "conflict/lack of collaboration"
  }.freeze
end
