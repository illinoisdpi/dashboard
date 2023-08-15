module Impression::Emojiable
    extend ActiveSupport::Concern
  
    EMOJIS = {
        👍: "positive",
        👎: "negative",
        🙋: "asking questions",
        😇: "helping others",
        🥳: "growth",
        😬: "unprofessional",
        😠: "lashing out",
        🤩: "all star",
        😶: "lack communication",
        😑: "lack progress",
        ⏰: "time management"
    }.freeze
end