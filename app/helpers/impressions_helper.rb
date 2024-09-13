module ImpressionsHelper
  def formatted_emoji_buttons(emoji_array)
    emoji_array.map do |emoji|
      {
        emoji: emoji,
        category: Impression::Emojiable::EMOJI_CATEGORIES[emoji],
        description: Impression::Emojiable::EMOJI_DESCRIPTIONS[emoji]
      }
    end
  end
end
