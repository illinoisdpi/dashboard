xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "WE-PTTL Blog"
    xml.description "This is a blog by Discovery Partners Institute Workforce Education"
    xml.link root_url

    @articles.each do |article|
      xml.item do
        xml.title article.title
        xml.description article.description
        xml.pubDate article.published_at.to_s(:rfc822)
        xml.link article.url
        xml.guid article.devto_id
      end
    end
  end
end
