module ApplicationHelper
  def rating_class(rating)
    case rating
    when :excellent
      "success"
    when :proficient
      "info"
    when :emerging
      "primary"
    else
      "primary"
    end
  end

  def render_markdown(text)
    markdown_renderer.render(text).html_safe
  end

  private
  
  def markdown_renderer
    renderer = Redcarpet::Render::HTML.new(filter_html: true, hard_wrap: true)
    Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
  end
end
