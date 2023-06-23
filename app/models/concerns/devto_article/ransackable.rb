module DevtoArticle::Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      [
        "title",
        "description"
      ]
    end

    def ransackable_associations(auth_object = nil)
      [
        "author"
      ]
    end
  end
end
