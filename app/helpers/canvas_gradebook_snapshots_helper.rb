module CanvasGradebookSnapshotsHelper
  def markdown_renderer
    renderer = Redcarpet::Render::HTML.new(filter_html: true, hard_wrap: true)
    Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
  end
  def render_markdown(text)
    markdown_renderer.render(text).html_safe
  end
end
