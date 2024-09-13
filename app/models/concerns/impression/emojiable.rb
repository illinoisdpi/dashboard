module Impression::Emojiable
  extend ActiveSupport::Concern

  included do
    validates :emoji, emoji: true
  end

  EMOJI_CATEGORIES = {
    "💼" => "consistency",
    "🧥" => "consistency",
    "🙌" => "committed",
    "💯" => "committed",
    "🚀" => "confidence",
    "🤝" => "collaboration",
    "🛜" => "collaboration",
    "💪" => "character",
    "🪞" => "character",
    "🤗" => "character",
    "📣" => "communication",
    "🫡" => "communication",
    "⏰" => "consistency",
    "🧢" => "consistency",
    "🤷" => "committed",
    "🫤" => "committed",
    "🦥" => "confidence",
    "🥊" => "collaboration",
    "🙈" => "collaboration",
    "😬" => "character",
    "😯" => "character",
    "👿" => "character",
    "🙊" => "communication",
    "💢" => "communication",
    "👍" => "miscellaneous",
    "👎" => "miscellaneous",
    "😡" => "miscellaneous",
    "🙋" => "miscellaneous",
    "😇" => "miscellaneous",
    "🥳" => "miscellaneous",
    "🤔" => "miscellaneous"
  }.freeze

  EMOJI_DESCRIPTIONS = {
    "🧥" => "attendance and punctuality",
    "💼" => "workplace appearance",
    "🙌" => "follow-through",
    "💯" => "quality of work",
    "🚀" => "taking initiative",
    "🤝" => "teamwork",
    "🛜" => "networking",
    "💪" => "resilience",
    "🪞" => "self-awareness",
    "🤗" => "positive attitude",
    "📣" => "communication skills",
    "🫡" => "positive response to supervision",
    "⏰" => "poor time management",
    "🧢" => "unprofessional workplace appearance",
    "🤷" => "lack of follow-through",
    "🫤" => "low quality of work",
    "🦥" => "lack of initiative",
    "🥊" => "conflict/lack of collaboration",
    "🙈" => "lack of networking",
    "😬" => "lack of resilience",
    "😯" => "lacking self-awareness",
    "👿" => "negative attitude",
    "🙊" => "poor communication skills",
    "💢" => "negative response to supervision",
    "👍" => "positive",
    "👎" => "negative",
    "😡" => "poor workplace culture and policy",
    "🙋" => "asking questions",
    "😇" => "helping others",
    "🥳" => "growth",
    "🤔" => "problem solving"
  }.freeze

  POSITIVE_EMOJIS = [
    "🧥", "💼", "🙌", "💯", "🚀", "🤝", "🛜", "💪", "🪞", "🤗", "📣", "🫡"
  ].freeze

  NEGATIVE_EMOJIS = [
    "⏰", "🧢", "🤷", "🫤", "🦥", "🥊", "🙈", "😬", "😯", "👿", "🙊", "💢"
  ].freeze

  DEPRECATED_EMOJIS = [
    "👍", "👎", "😡", "🙋", "😇", "🥳", "🤔"
  ].freeze

  ALL_EMOJIS = POSITIVE_EMOJIS + NEGATIVE_EMOJIS + DEPRECATED_EMOJIS

  CATEGORIES = EMOJI_CATEGORIES.values.uniq.freeze

  def emoji_category
    EMOJI_CATEGORIES[emoji] || "Unknown Category"
  end

  def emoji_description
    EMOJI_DESCRIPTIONS[emoji] || "Description not available"
  end
end
