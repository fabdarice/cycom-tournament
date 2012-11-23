module ApplicationHelper
  # Display the title with the good html structure, used for style
  def h2(title)
    "<h2><div><span>#{title}</span></div></h2>".html_safe
  end
  
  def action_box(&block)
    content = capture(&block)
    
    content_tag(:ul, content, :id => 'action-box') unless content.blank?
  end
end
