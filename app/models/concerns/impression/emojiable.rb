module Impression::Emojiable
  extend ActiveSupport::Concern

  included do
    validates :emoji, emoji: true
  end

  def emoji_name
    Impression::EMOJIS[emoji.to_sym] || Emoji.find_by_unicode(emoji).name
  end

  POSITIVE_EMOJIS = {
    # 👍: ["misc", "positive"],
    # 🤔: ["misc", "problem solving"],
    # 😇: ["misc", "helping others"],
    # 🙋: ["misc", "asking questions"],
    # 🥳: ["misc", "growth"],
    🧥: ["Consistency", "Attendance and Punctuality"],
    💼: ["Consistency", "Workplace Appearance"],
    🙌: ["Committed", "Follow-through"],
    💯: ["Committed", "Quality of Work"],
    🚀: ["Confidence", "Taking Initiative"],
    🤝: ["Collaboration", "Teamwork"],
    🛜: ["Collaboration", "Networking"],
    💪: ["Character", "Resilience"],
    🪞: ["Character", "Self-awareness"],
    🤗: ["Character", "Positive Attitude"],
    📣: ["Communication", "communication skills"],
    🫡: ["Communication", "positive response to supervision"],
  }.freeze

  NEGATIVE_EMOJIS = {
    👎: "negative",
    🧢: "unprofessional workplace appearance",
    😡: "poor workplace culture and policy",
    🤷: "lack of follow-through",
    🫤: "low quality of work",
    🦥: "lack of initiative",
    🙊: "poor communication skills",
    💢: "negative response to supervision",
    🥊: "conflict/lack of collaboration",
    😯: "lacking self-awareness",
    👿: "negative attitude",
    😬: "unprofessional",
    ⏰: "poor time management"
  }.freeze

  EMOJIS = POSITIVE_EMOJIS.merge(NEGATIVE_EMOJIS).freeze
end
