module Impression::Emojiable
  extend ActiveSupport::Concern

  included do
    validates :emoji, presence: true, inclusion: { in: EMOJIS.keys.map(&:to_s), message: "%{value} is not a valid emoji" }
  end

  EMOJIS = {
    "💼": { sentiment: :positive, category: "consistency", description: "workplace appearance" },
    "🧥": { sentiment: :positive, category: "consistency", description: "attendance and punctuality" },
    "🙌": { sentiment: :positive, category: "committed", description: "follow-through" },
    "💯": { sentiment: :positive, category: "committed", description: "quality of work" },
    "🚀": { sentiment: :positive, category: "confidence", description: "taking initiative" },
    "🤝": { sentiment: :positive, category: "collaboration", description: "teamwork" },
    "🛜": { sentiment: :positive, category: "collaboration", description: "networking" },
    "💪": { sentiment: :positive, category: "character", description: "resilience" },
    "🪞": { sentiment: :positive, category: "character", description: "self-awareness" },
    "🤗": { sentiment: :positive, category: "character", description: "positive attitude" },
    "📣": { sentiment: :positive, category: "communication", description: "communication skills" },
    "🫡": { sentiment: :positive, category: "communication", description: "positive response to supervision" },
    "⏰": { sentiment: :negative, category: "consistency", description: "poor time management" },
    "🧢": { sentiment: :negative, category: "consistency", description: "unprofessional workplace appearance" },
    "🤷": { sentiment: :negative, category: "committed", description: "lack of follow-through" },
    "🫤": { sentiment: :negative, category: "committed", description: "low quality of work" },
    "🦥": { sentiment: :negative, category: "confidence", description: "lack of initiative" },
    "🥊": { sentiment: :negative, category: "collaboration", description: "conflict/lack of collaboration" },
    "🙈": { sentiment: :negative, category: "collaboration", description: "lack of networking" },
    "😬": { sentiment: :negative, category: "character", description: "lack of resilience" },
    "😯": { sentiment: :negative, category: "character", description: "lacking self-awareness" },
    "👿": { sentiment: :negative, category: "character", description: "negative attitude" },
    "🙊": { sentiment: :negative, category: "communication", description: "poor communication skills" },
    "💢": { sentiment: :negative, category: "communication", description: "negative response to supervision" }
  }.freeze

  CATEGORIES = EMOJIS.values.pluck(:category).uniq.freeze

  %i[category description sentiment].each do |attribute|
    define_method("emoji_#{attribute}") do
      EMOJIS.dig(emoji.to_sym, attribute) || "Unknown #{attribute.capitalize}"
    end
  end

  %i[positive negative].each do |sentiment|
    define_singleton_method("#{sentiment}_emojis") do
      EMOJIS.keys.filter do |emoji|
        EMOJIS[emoji][:sentiment] == sentiment
      end
    end
  end

  def self.emojis_for_category(category)
    EMOJIS.select { |_, v| v[:category].casecmp?(category) }.keys
  end
end
