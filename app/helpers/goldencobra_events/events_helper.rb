module GoldencobraEvents
  module EventsHelper
    
    def render_registration_basket()
        render :partial => "goldencobra_events/events/registration_basket"
    end
    
    def render_article_events(options={})
      if params[:webcode] && GoldencobraEvents::EventPricegroup.select(:webcode).map(&:webcode).include?(params[:webcode])
        session[:goldencobra_events_webcode] = params[:webcode] 
      end
      if @article && @article.event_id.present? && @article.event && @article.event.active
        depth = @article.event_levels || 0
        class_name = options[:class] || ""
        content = ""
        content << event_item_helper(@article.event, depth, 1, options)
        result = content_tag(:ul, raw(content), :class => "#{class_name} depth_#{depth} article_events level_1".squeeze(' ').strip)
        result = content_tag(:div, raw(result), :id => "goldencobra_events_article_events", :class=> @article.eventmoduletype)
        title_content = content_tag(:h2, "#{@article.title}", :class => "boxheader")
        return_content = content_tag(:div, raw(title_content), :class => "article_title")
        return_content << content_tag(:div, render(:partial => "goldencobra_events/events/webcode_form"), :id => "article_event_webcode_form" )
        return_content += result
        return_content += content_tag(:div, link_to(s("goldencobra_events.event.registration.enter_user_data"), "#", :id => "goldencobra_events_enter_account_data"), :id => "goldencobra_events_enter_account_data_wrapper", :style => "display:none")
        return_content += content_tag(:div, render(:partial => "goldencobra_events/events/user"), :style => "display:none", :id => "goldencobra_events_enter_account_data_form")
        return raw(return_content)
      else
        #TODO: mandatory article event fields als option parameters if no article exist (a.eventmoduletype, a.event_levels, ) => Article.new(options...)
        ""#"no Article and therefore no event Selected"
      end
    end 

    private
    def event_item_helper(child, depth, current_depth, options)
      if @article.eventmoduletype == "program" || (@article.eventmoduletype == "registration" && (child.has_registerable_childrens? || child.needs_registration?)) 
        child_block = render_child_block(child, options) 
        current_depth = current_depth + 1
        if child.children && (depth == 0 || current_depth <= depth)
          content_level = ""
          if (@article.eventmoduletype == "registration" && child.has_registerable_childrens?)  || @article.eventmoduletype == "program"
            child.children.active.each do |subchild|
                if subchild.is_visible?({:webcode => session[:goldencobra_events_webcode], :article => @article})
                  content_level << event_item_helper(subchild, depth, current_depth, options)
                end
            end
          end
          if content_level.present?
            css_style = @article.eventmoduletype == "registration" ? "display:none" : ""
            child_block = child_block + content_tag(:ul, raw(content_level), class: "sub_events level_#{current_depth}", :style => css_style )
          end
        end  
        return content_tag(:li, raw(child_block), class: "article_event_id_#{child.id} article_event_item #{child.registration_css_class} #{child.exclusive ? 'has_exclusive_children' : ''}")
      else
        return ""
      end
    end

    def render_object(model, *args)
      content = ""
      args.each do |a|
        content << content_tag(:div, raw(model.send(a)), class: a) if model && model.respond_to?(a)
      end
      return content
    end

    def render_object_image(model, type="images", options={})
      # Call method to display model's images.
      # Use options={:size => :thumb|:small|:medium|:large|:original} to specify
      # different sizes. It's embedded within an <ahref> and links to the original image
      if options[:size].blank?
        options = {:size => :thumb}
      end

      content = ""
      if type == "images" && model && model.respond_to?(:images)
        img_items = ""
        model.images.each do |img|
          img_content = content_tag(:img, '', src: "#{img.image.url(options[:size])}", class: "#{model.class.to_s.underscore.gsub('/','_')}_image_#{img.id} #{model.class.to_s.underscore.gsub('/','_')}_image")
          a_content = content_tag(:a, raw(img_content), href: "#{img.image.url(:large)}", class: "#{model.class.to_s.underscore.gsub('/','_')}_image_#{img.id}_link")
          img_items << content_tag(:li, raw(a_content), class: "#{model.class.to_s.underscore.gsub('/','_')}_#{model.id}_image_item")
        end
        images = content_tag(:ul, raw(img_items), class: "goldencobra_#{model.class.to_s.underscore.gsub('/','_')}_images")
        content << content_tag(:div, raw(images), class: "#{model.class.to_s.underscore.gsub('/','_')}_content_images")
      else
        if model.respond_to?(type) && model.send(type).respond_to?(:image) && model.send(type).image.present?
          img_content = content_tag(:img, '', src: "#{model.send(type).image.url(options[:size])}", class: "#{model.class.to_s.underscore.gsub('/','_')}_#{type}")
          content << content_tag(:a, raw(img_content), href: "#{model.send(type).image.url(:large)}", class: "#{model.class.to_s.underscore.gsub('/','_')}_#{type}_image_link")
        end
      end
      return content
    end

    def render_child_block(event, options)
      # Event
      content = render_object(event, :title)
      event_options = render_object(event, :number_of_participators_label, :type_of_registration)
      if event.needs_registration? && @article.eventmoduletype == "registration"
        event_options << render_object(event, :type_of_event)
      else
        event_options << render_object(event, :type_of_event)
      end
      if event.exclusive == true
        event_options << render_object(event, :exclusive)
      end
      content << content_tag(:div,raw(event_options), :class => "event_reservation_options" ) 
      content << render_object(event, :description, :external_link,  :start_date, :end_date)
      content << render_object_image(event, "teaser_image")

      # Venue
      venue = render_object(event.venue, :title, :description, :location_values, :link_url, :phone, :email)
      content << content_tag(:div, raw(venue), class: "venue")
      
      #Anmeldelink anzeigen
      if event.needs_registration? && @article.eventmoduletype == "registration"
        reg_link = link_to(s("goldencobra_events.event.article_events.register_text"), "/goldencobra_events/event/#{event.id}/register" ,:remote => true, :id => "register_for_event_#{event.id}_link")
        content << content_tag(:div, reg_link, :class => "register_for_event", "data-id" => event.id, :id => "register_for_event_#{event.id}")
      end

      
      # Pricegroups
      pricegroup_items = ""
      event.event_pricegroups.available.each do |event_pricegroup|
        event_pricegroup_item = render_object(event_pricegroup, :pricegroup_id, :title)
        event_pricegroup_item << content_tag(:div, number_to_currency(event_pricegroup.price), :class => "price")
        event_pricegroup_item << render_object(event_pricegroup, :number_of_participators_label, :cancelation_until, :start_reservation, :end_reservation)
        pricegroup_items << content_tag(:li, raw(event_pricegroup_item), class: "pricegroup_item_#{event_pricegroup.pricegroup_id} event_pricegroup_id_#{event_pricegroup.id}")
      end
      pricegroups = content_tag(:p, "Available Pricegroups", class: "pricegroup_header")
      pricegroups << content_tag(:ul, raw(pricegroup_items), class: "pricegroup_list")
      content << content_tag(:div, raw(pricegroups), class: "pricegroups")

      # Sponsors
      sponsors_items = ""
      event.event_sponsors.each do |event_sponsor|
        event_sponsor_item = render_object(event_sponsor.sponsor, :title, :description, :link_url, :size_of_sponsorship, :type_of_sponsorship, :telephone, :email)
        event_sponsor_item << render_object(event_sponsor.sponsor.location, :complete_location)
        event_sponsor_item << render_object_image(event_sponsor.sponsor, "logo")
        event_sponsor_item << render_object_image(event_sponsor.sponsor, "images")
        sponsors_items << content_tag(:li, raw(event_sponsor_item), class: "sponsor_item sponsor_item_#{event_sponsor.sponsor.id}")
      end
      sponsors = content_tag(:ul, raw(sponsors_items), class: "sponsor_list")
      content << content_tag(:div, raw(sponsors), class: "sponsors")

      # Artists
      artists_items = ""
      event.artist_events.each do |artist_event|
        artist_event_item = render_object(artist_event.artist, :title, :description, :url_link, :telephone, :email)
        artist_event_item << render_object(artist_event.artist.location, :complete_location)
        artist_event_item << render_object_image(artist_event.artist, "images")
        artists_items << content_tag(:li, raw(artist_event_item), class: "artist_item_#{artist_event.artist.id}")
      end
      artists = content_tag(:ul, raw(artists_items), class: "artist_list")
      content << content_tag(:div, raw(artists), class: "artists")
      
      if @article.eventmoduletype == "registration"
        if event.needs_registration?
          return content_tag(:div, raw(content), class: "article_event_content")          
        else
          if event.exclusive
            return content_tag(:div, raw(s("goldencobra_events.event.registration.exclusive_description")), class: "article_event_content")
          else
            return content_tag(:div, "", class: "article_event_content")
          end
        end
      else
          return content_tag(:div, raw(content), class: "article_event_content")
      end
    end

      
  end
end
