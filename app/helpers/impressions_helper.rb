module ImpressionsHelper
  def focused_emojis(emojis)
    emojis.reject { |emoji| Impression::Emojiable::EMOJIS[emoji][:category] == "miscellaneous" }
  end
end
