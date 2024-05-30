module Impression::Emojiable
  extend ActiveSupport::Concern

  included do
    validates :emoji, emoji: true
  end

  def emoji_name
    Impression::EMOJIS[emoji.to_sym] || Emoji.find_by_unicode(emoji).name
  end

  def emoji_name
    Impression::EMOJIS[emoji.to_sym] || Emoji.find_by_unicode(emoji).name
  end

  POSITIVE_EMOJIS = {
    🧥: "workplace appearance",
    💼: "workplace culture and policy",
    🙌: "follow-through",
    💯: "quality of work",
    ⚡️: "taking initiative",
    🗣️: "communication skills",
    🫡: "response to supervision",
    👯‍♂️: "teamwork",
    🛜: "networking",
    🤔: "problem solving",
    💪: "resilience",
    🪞: "self-awareness",
    🤗: "attitude",
    👍: "positive",
    🙋: "asking questions",
    😇: "helping others",
    🥳: "growth",
    👎: "negative",
    😬: "unprofessional",
    🚧: "conflict/lack of collaboration",
    ⏰: "time management"
  }.freeze

  NEGATIVE_EMOJIS = {}.freeze

  EMOJIS = POSITIVE_EMOJIS.merge(NEGATIVE_EMOJIS).freeze
end
