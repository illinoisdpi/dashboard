module ImpressionsHelper
  def formatted_emojis_by_sentiment(sentiment)
    emojis = Impression.emojis_by_sentiment(sentiment)
    emojis.map do |emoji|
      {
        emoji: emoji,
        category: Impression::Emojiable::EMOJIS[emoji][:category],
        description: Impression::Emojiable::EMOJIS[emoji][:description]
      }
    end
  end
end
