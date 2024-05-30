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
    👍: "general comment",
    🧥: "workplace appearance",
    💼: "workplace culture and policy",
    🙌: "follow-through",
    💯: "quality of work",
    ⚡️: "taking initiative",
    🗣️: "communication skills",
    🫡: "positive response to supervision",
    👯‍♂️: "teamwork",
    🛜: "networking",
    🤔: "problem solving",
    💪: "resilience",
    🪞: "self-awareness",
    🤗: "positive attitude",
    🙋: "asking questions",
    😇: "helping others",
    🥳: "growth"
  }.freeze

  NEGATIVE_EMOJIS = {
    👎: "general comment",
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
