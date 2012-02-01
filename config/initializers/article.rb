Goldencobra::Article.class_eval do
  belongs_to :event, :class_name => GoldencobraEvents::Event
    
end

Goldencobra::ArticlesHelper.module_eval do
  def render_article_events(options={})
    if @article && @article.event_id.present? && @article.event
      depth = @article.event_levels || 0
      class_name = options[:class] || ""
      id_name = options[:id] || ""
      content = ""
      @article.event.children.collect do |child|
        content << event_item_helper(child, depth, 1)
      end
      result = content_tag(:ul, raw(content),:id => "#{id_name}", :class => "#{class_name} #{depth} article_events".squeeze(' ').strip)
      return raw(result)
    end
  end 
  
  
  private
  def event_item_helper(child, depth, current_depth)
    child_link = child.title
    current_depth = current_depth + 1
    if child.children && (depth == 0 || current_depth <= depth)
      content_level = ""
      child.children.each do |subchild|
          content_level << event_item_helper(subchild, depth, current_depth)
      end
      if content_level.present?
        child_link = child_link + content_tag(:ul, raw(content_level), :class => "level_#{current_depth}" )
      end
    end  
    return content_tag(:li, raw(child_link), :class => "article_event_item")
  end
    
end

