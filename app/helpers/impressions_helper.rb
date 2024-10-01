module ImpressionsHelper
  def non_miscellaneous_emojis(emojis)
    emojis.reject { |emoji| Impression::Emojiable::EMOJIS[emoji][:category] == "miscellaneous" }
  end
end
