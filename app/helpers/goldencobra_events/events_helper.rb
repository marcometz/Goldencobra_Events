module GoldencobraEvents
  module EventsHelper
    
    def render_registration_basket()
        render :partial => "goldencobra_events/events/registration_basket"
    end
    
    def render_article_events(options={})
      if @article && @article.event_id.present? && @article.event && @article.event.active
        depth = @article.event_levels || 0
        class_name = options[:class] || ""
        id_name = options[:id] || "goldencobra_events_article_events"
        content = ""
        content << event_item_helper(@article.event, depth, 1, options)
        result = content_tag(:ul, raw(content),:id => "#{id_name}", :class => "#{class_name} depth_#{depth} article_events".squeeze(' ').strip)
        return raw(result)
      end
    end 


    private
    def event_item_helper(child, depth, current_depth, options)
      child_block = render_child_block(child, options)
      current_depth = current_depth + 1
      if child.children && (depth == 0 || current_depth <= depth)
        content_level = ""
        child.children.active.each do |subchild|
            content_level << event_item_helper(subchild, depth, current_depth, options)
        end
        if content_level.present?
          child_block = child_block + content_tag(:ul, raw(content_level), class: "level_#{current_depth}" )
        end
      end  
      return content_tag(:li, raw(child_block), class: "article_event_item")
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
      content = render_object(event, :title, :description, :external_link, :max_number_of_participators, :type_of_event, :type_of_registration, :exclusive, :start_date, :end_date)
      content << render_object_image(event, "teaser_image")
      if event.needs_registration? && options[:registration_links] != false
        reg_link = link_to(s("goldencobra_events.event.article_events.register_text"), "/goldencobra_events/event/#{event.id}/register" ,:remote => true)
        content << content_tag(:div, reg_link, :class => "register_for_event register_for_event_#{event.id}", "data-id" => event.id)
      end

      # Venue
      venue = render_object(event.venue, :title, :description, :location_values, :link_url, :phone, :email)
      content << content_tag(:div, raw(venue), class: "venue")
      # Pricegroups
      pricegroup_items = ""
      event.event_pricegroups.available.each do |event_pricegroup|
        event_pricegroup_item = render_object(event_pricegroup, :pricegroup_id, :title, :price, :max_number_of_participators, :cancelation_until, :start_reservation, :end_reservation)
        pricegroup_items << content_tag(:li, raw(event_pricegroup_item), class: "pricegroup_item_#{event_pricegroup.pricegroup_id}")
      end
      pricegroups = content_tag(:ul, raw(pricegroup_items), class: "pricegroup_list")
      content << content_tag(:div, raw(pricegroups), class: "pricegroups")

      # Sponsors
      sponsors_items = ""
      event.event_sponsors.each do |event_sponsor|
        event_sponsor_item = render_object(event_sponsor.sponsor, :title, :description, :link_url, :size_of_sponsorship, :type_of_sponsorship, :telephone, :email)
        event_sponsor_item << render_object(event_sponsor.sponsor.location, :complete_location)
        event_sponsor_item << render_object_image(event_sponsor.sponsor, "logo")
        event_sponsor_item << render_object_image(event_sponsor.sponsor, "images")
        sponsors_items << content_tag(:li, raw(event_sponsor_item), class: "sponsor_item_#{event_sponsor.sponsor.id}")
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

      return content_tag(:div, raw(content), class: "article_event_content")
    end
    
    
  end
end
