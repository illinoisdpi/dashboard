module DevtoArticle::UTMTrackable
  extend ActiveSupport::Concern

  def utm_params
    {
      utm_source: "news.dpi.dev",
    # TODO: other utm stuff as needed
    }
  end

  def url_with_utm
    "#{url}?#{utm_params.to_query}"
  end
end
