module Impression::Emojiable
  extend ActiveSupport::Concern

  included do
    validates :emoji, emoji: true
  end

  def emoji_category
    Impression::EMOJIS[emoji.to_sym]&.fetch(:category, "Unknown Category")
  end

  def emoji_description
    Impression::EMOJIS[emoji.to_sym]&.fetch(:description, "Description not available")
  end

  POSITIVE_EMOJIS = {
    🧥: {category: "Consistency", description: "Attendance and Punctuality"},
    💼: {category: "Consistency", description: "Workplace Appearance"},
    🙌: {category: "Committed", description: "Follow-through"},
    💯: {category: "Committed", description: "Quality of Work"},
    🚀: {category: "Confidence", description: "Taking Initiative"},
    🤝: {category: "Collaboration", description: "Teamwork"},
    🛜: {category: "Collaboration", description: "Networking"},
    💪: {category: "Character", description: "Resilience"},
    🪞: {category: "Character", description: "Self-awareness"},
    🤗: {category: "Character", description: "Positive Attitude"},
    📣: {category: "Communication", description: "Communication Skills"},
    🫡: {category: "Communication", description: "Positive Response to Supervision"}
  }.freeze

  NEGATIVE_EMOJIS = {
    ⏰: {category: "Consistency", description: "Poor Time Management"},
    🧢: {category: "Consistency", description: "Unprofessional Workplace Appearance"},
    🤷: {category: "Committed", description: "Lack of Follow-through"},
    🫤: {category: "Committed", description: "Low Quality of Work"},
    🦥: {category: "Confidence", description: "Lack of Initiative"},
    🥊: {category: "Collaboration", description: "Conflict/Lack of Collaboration"},
    🙈: {category: "Collaboration", description: "Lack of Networking"},
    😬: {category: "Character", description: "Lack of Resilience"},
    😯: {category: "Character", description: "Lacking Self-awareness"},
    👿: {category: "Character", description: "Negative Attitude"},
    🙊: {category: "Communication", description: "Poor Communication Skills"},
    💢: {category: "Communication", description: "Negative Response to Supervision"}
  }.freeze

  DEPRECATED_EMOJIS = {
      '👍': {category: "Miscellaneous", description: "Positive"},
      '👎': {category: "Miscellaneous", description: "Negative"},
      '😡': {category: "Miscellaneous", description: "Poor Workplace Culture and Policy"},
      '🙋': {category: "Miscellaneous", description: "Asking Questions"},
      '😇': {category: "Miscellaneous", description: "Helping Others"},
      '🥳': {category: "Miscellaneous", description: "Growth"},
      '🤔': {category: "Miscellaneous", description: "Problem Solving"}
    }.freeze

  EMOJIS = POSITIVE_EMOJIS.merge(NEGATIVE_EMOJIS).merge(DEPRECATED_EMOJIS).freeze
  POSITIVE_EMOJI_KEYS = POSITIVE_EMOJIS.keys.map(&:to_s).freeze
  NEGATIVE_EMOJI_KEYS = NEGATIVE_EMOJIS.keys.map(&:to_s).freeze
  
end
