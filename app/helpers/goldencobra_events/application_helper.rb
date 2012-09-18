module GoldencobraEvents
  module ApplicationHelper
    def jquery(html_options = {}, &block)
      content = ''.tap do |js|
        js << '(function($){' 
        js << '$(document).ready(function(){'
        js << capture(&block)
        js << '})'
        js << '})(jQuery);'
      end
      tag = content_tag(:script, javascript_cdata_section(content), html_options.merge(:type => Mime::JS, :defer => 'defer'))
    end
  end
end
