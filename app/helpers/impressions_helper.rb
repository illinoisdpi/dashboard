module ImpressionsHelper
  def formatted_emoji_buttons(emoji_array)
    emoji_array.map do |emoji|
      {
        emoji: emoji,
        category: Impression::Emojiable::EMOJIS[emoji][:category],
        description: Impression::Emojiable::EMOJIS[emoji][:description]
      }
    end
  end
end
