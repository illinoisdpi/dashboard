class EmojiValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    emoji_regex = /\A\p{Emoji}\z/

    unless emoji_regex.match?(value)
      record.errors.add(attribute, "must be a single valid emoji")
    end
  end
end
