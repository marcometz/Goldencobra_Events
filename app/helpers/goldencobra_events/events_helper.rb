module GoldencobraEvents
  module EventsHelper
    
    
    #ein popup für die AGBS im Eventmodul. 
    def event_agb_popup(options={})
      art_id = Goldencobra::Setting.find_by_title("agb_article_id")
      if art_id.present? && art_id.value != "0"
        title = options[:title].present? ? options[:title] : "AGBs anzeigen"
        link_to(title, "/goldencobra_events/display_agb" , :remote => true, :id => "goldencobra_events_agbpopup_link")
      end
    end
    
    #ausgabe eine warenkorbs bereits gebuchter events
    def render_registration_basket()
        render :partial => "goldencobra_events/events/registration_basket"
    end
    
    #ausgabe aler sponsoren einer seite
    def render_article_sponsors(options={})
      class_name = options[:class] || ""
      if @article && @article.event_for_sponsor_id.present?
        depth = @article.event_for_sponsor_levels || 0
        content = ""
        if @article.sponsor_list.present?
          list = @article.sponsor_list.sort {|a,b| a[1].to_i <=> b[1].to_i}
          list = list.map{|element| element[0]}.delete_if{|a| a.include?('display_')}.delete_if{|a| @article.sponsor_list["display_#{a}"].present? && @article.sponsor_list["display_#{a}"] == "0"}
        else
          list = (@article.event && @article.event.sponsors.count > 0) ? @article.event.sponsors.map{|a| a.id} : []
          list = list.sort
        end
        list.each do |sponsor_id|
          content += content_tag(:li, render_sponsors_block(sponsor_id), class: "sponsor_item_#{sponsor_id}")
        end
        result = content_tag(:ul, raw(content), :class => "#{class_name} sponsor_list".squeeze(' ').strip)
        return raw(result)
      end
    end
    
    
    #ausgabe aller künstler einer seite
    def render_article_artists(options={})
      class_name = options[:class] || ""
      if @article && @article.event_for_artists_id.present?
        depth = @article.event_for_artists_levels || 0
        content = ""
        if @article.artist_list.present?
          list = @article.artist_list.sort {|a,b| a[1].to_i <=> b[1].to_i}
          list = list.map{|element| element[0]}.delete_if{|a| a.include?('display_')}.delete_if{|a| @article.artist_list["display_#{a}"].present? && @article.artist_list["display_#{a}"] == "0"}
        else
          list = @article.event.artists.map{|a| a.id}
          list = list.sort
        end
        list.each do |artist_id|
          content += content_tag(:li, render_artists_block(artist_id), class: "artist_item_#{artist_id}")
        end
        result = content_tag(:ul, raw(content), :class => "#{class_name} article_list".squeeze(' ').strip)
        return raw(result)
      end
    end
    
    #ausgabe aller events  auf eienr seite als liste oder als anmeldeformular
    def render_article_events(options={})
      #reset der Session damit beim erneuten laden keine alten bestelldaten enthalten sind
      session[:goldencobra_event_registration] = nil if session[:goldencobra_event_registration]
      if params[:webcode] && params[:webcode].present?
        session[:goldencobra_events_webcode] = params[:webcode] 
      end
      if @article && @article.event_id.present? && @article.event && @article.event.active
        depth = @article.event_levels || 0
        class_name = options[:class] || ""
        content = ""
        content << event_item_helper(@article.event, depth, 1, options)

        # Darstellung des Programms        
        if @article.eventmoduletype == "program"
          result = content_tag(:ul, raw(content), :class => "#{class_name} depth_#{depth} article_events level_1".squeeze(' ').strip)
          result = content_tag(:div, raw(result), :id => "goldencobra_events_article_events", :class=> "#{@article.eventmoduletype} eventprogramm")          
          # Webcode ist hier erstmal überflüssig, "versteckte" Events sollen hier ohnehin nicht angezeigt werden
          # return_content = content_tag(:div, render(:partial => "goldencobra_events/events/webcode_form"), :id => "article_event_webcode_form" )
          
          # Anmeldebutton und Formular werden hier nicht benötigt, die Ausgabe bleibt also wie sie ist
          return_content = result
        
        # Darstellung des Anmeldeformulars
        else
          result = content_tag(:ul, raw(content), :class => "#{class_name} depth_#{depth} article_events level_1".squeeze(' ').strip)
          # Wird derzeit nicht mehr benötigt und wird deshalb aktuell nicht angezeigt.
          # result << content_tag(:p, "#{raw(s("goldencobra_events.event.registration.price_informations"))}", class: "price_informations")
          return_content = content_tag(:div, raw(result), :id => "goldencobra_events_article_events", :class=> "#{@article.eventmoduletype}")
          # return_content += content_tag(:div, render(:partial => "goldencobra_events/events/webcode_form"), :id => "article_event_webcode_form" )
          return_content += content_tag(:div, link_to(s("goldencobra_events.event.registration.enter_user_data"), "#", :id => "goldencobra_events_enter_account_data", :class => "button"), :id => "goldencobra_events_enter_account_data_wrapper", :style => "display:none")
          return_content += content_tag(:div, render(:partial => "goldencobra_events/events/user"), :style => "display:none", :id => "goldencobra_events_enter_account_data_form")
        end
        return raw(return_content)
      else
        
          #TODO: mandatory article event fields als option parameters if no article exist (a.eventmoduletype, a.event_levels, ) => Article.new(options...)
          ""#"no Article and therefore no event Selected"
      end
    end 

    private  
    
    def render_sponsors_block(sponsor_id)
      sponsor = GoldencobraEvents::Sponsor.find(sponsor_id)

      sponsor_item = ""

      #image block
      if sponsor.logo
        sponsor_image_content = content_tag(:img, '', src: "#{sponsor.logo.image.url(:medium)}", class: "sponsor_logo")
        sponsor_image = content_tag(:p, raw(sponsor_image_content), class: "sponsor-image")
        sponsor_item << sponsor_image
      end

      #Adress block
      if sponsor.location
        sponsor_vcard_content = content_tag(:p, sponsor.location.street)
        sponsor_vcard_content << content_tag(:p, "#{sponsor.location.zip} #{sponsor.location.city}")
        sponsor_vcard_content << content_tag(:p, sponsor.location.country)
        sponsor_items_vcard = content_tag(:div, raw(sponsor_vcard_content), class: "adr")
      end

      #Contact block
      sponsor_contact_content = render_object(sponsor, :telephone, :email, :link_url)
      sponsor_items_vcard << content_tag(:div, raw(render_object(sponsor, :telephone, :email, :link_url)))

      #Adress + Contact
      sponsor_item << content_tag(:div, raw(sponsor_items_vcard), :class => "vcard")
      
      sponsor_description = content_tag(:p, raw(sponsor.description))
      sponsor_item << content_tag(:div, raw(sponsor_description), class: "sponsor-description")
      #sponsor_item << render_artist(sponsor, :title, :description, :link_url, :telephone, :email, :size_of_sponsorship, :type_of_sponsorship)
      #sponsor_item << render_object(sponsor.location, :complete_location)
      #sponsor_item << render_object_image(sponsor, "logo")
      #sponsor_item << render_object_image(sponsor, "images")
      return raw(sponsor_item)      
    end
          
    def render_artists_block(artist_id)
        artist = GoldencobraEvents::Artist.find(artist_id)
        artist_event_item = render_artist(artist, :title, :description, :url_link, :telephone, :email)
        artist_event_item << render_object(artist.location, :complete_location)
        artist_event_item << render_object_image(artist, "images")
        return raw(artist_event_item)
    end

    def event_item_helper(child, depth, current_depth, options)
      if @article.eventmoduletype == "program" || (@article.eventmoduletype == "registration" && (child.has_registerable_childrens? || child.needs_registration? || child.registration_optional?)) 
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

        cp = ""
        if !child.is_root? && child.start_date && child.end_date && @article.eventmoduletype == "registration" && child.has_children?
          cp << content_tag(:p, "#{raw(s("goldencobra_events.event.registration.child_registration_informations"))}", class: 'reg_info')
          c_start = ""
          c_start << content_tag(:div, raw(child.title ), class: 'child-title') if child.title.present?
          cp << content_tag(:div, raw(c_start), class: 'parent_title')
          cp << content_tag(:div, "#{raw(child.start_date.strftime('%H:%M'))} bis #{raw(child.end_date.strftime('%H:%M'))}", class: 'start_to_end_time_child')
        end
        cp << child_block

        c = content_tag(:li, raw(cp), class: "article_event_id_#{child.id} article_event_item #{child.registration_css_class} #{child.exclusive ? 'has_exclusive_children' : ''}")
        return c

     else
        return ""
      end
    end

    def render_object(model, *args)
      content = ""
      args.each do |a|
        if model.class == GoldencobraEvents::Artist
          if a == :title
            content << content_tag(:p, raw(model.send(a)), class: a)
          elsif a == :description
              content << content_tag(:p, raw(model.send(a)), class: a)
          elsif a == (:link_url || :url || :link)
            content << content_tag(:a, raw(model.send(a)), href: "#{model.send(a)}", class: a)
          elsif a == :email
            content << content_tag(:a, model.send(a), href: "mailto:#{model.send(a)}", class: a)
          else
            content << content_tag(:div, raw(model.send(a)), class: a)
          end
        elsif model && model.respond_to?(a)
          if a == :start_date
            content << content_tag(:div, raw(localize(model.start_date, :format => :long)), class: a)
          elsif a == (:link_url || :url || :link)
            content << content_tag(:a, raw(model.send(a)), href: "#{model.send(a)}", class: a)
          elsif a == :email
            content << content_tag(:a, model.send(a), href: "mailto:#{model.send(a)}", class: a)
          else
            content << content_tag(:div, raw(model.send(a)), class: a)
          end
        end
      end
      return content
    end

    def render_artist(model, *args)
      content = ""
      args.each do |a|
        content << content_tag(:span, raw(model.send(a)), class: a) if model && model.respond_to?(a)
        content << "&nbsp;"
      end
      return content
    end

    def render_object_image(model, type="images", options={})
      # Call method to display model's images.
      # Use options={:size => :thumb|:small|:medium|:large|:original} to specify
      # different sizes. It's embedded within an <ahref> and links to the original image
      if options[:size].blank?
        options[:size] = :thumb
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
      return content_tag(:div,raw(content), :style => options[:style], :class => options[:class])
    end

    def render_child_block(event, options=nil)
      
      content = ""
      
      #Anmeldelink anzeigen
      if (event.needs_registration? || event.registration_optional?) && @article.eventmoduletype == "registration" && !event.is_root?
        reg_link = link_to(s("goldencobra_events.event.registration.choose_event"), "/goldencobra_events/event/#{event.id}/register" ,:remote => true, :id => "register_for_event_#{event.id}_link", :class => "button")
        content << content_tag(:div, reg_link, :class => "register_for_event", "data-id" => event.id, :id => "register_for_event_#{event.id}")
        #content << content_tag(:input, "", type: "checkbox", :id => "register_for_event_#{event.id}_checkbox", "data-id" => event.id, class: "register_for_event_checkbox")
        content << content_tag(:input, "", type: "radio", :name => "#{event.parent.id}", :id => "register_for_event_#{event.id}_checkbox", "data-id" => event.id, class: "register_for_event_checkbox")
        content << content_tag(:label, "#{event.title}", :for => "register_for_event_#{event.id}_checkbox", :class => "event_title_checkbox_label")
      end

      unless event.is_root?
        # Event
        if @article.eventmoduletype == "program" && !event.has_children? 
          content << content_tag(:p, raw("#{localize(event.start_date, format: '%H:%M')}&mdash;#{localize(event.end_date, format: '%H:%M')}" ), :class => "timeframe") if event.start_date && event.end_date
        end
        content << render_object(event, :title)
        unless event.has_children? #wir wollen nur bei den letzten Kinder-Events diese Infos anzeigen.
          content << render_object_image(event, "teaser_image", {:class => "teaser_image"} )
          content << render_object(event, :description, :external_link)
          event_options = render_object(event, :number_of_participators_label, :type_of_registration)
          if (event.needs_registration? || event.registration_optional?) && @article.eventmoduletype == "registration"
            event_options << render_object(event, :type_of_event)
          else
            event_options << render_object(event, :type_of_event)
          end
          if event.exclusive == true
            event_options << render_object(event, :exclusive)
          end
          content << content_tag(:div,raw(event_options), :class => "event_reservation_options" ) 
          content << content_tag(:div, raw( localize(event.start_date, format: :long) ), :class => "start_date") if event.start_date
          content << content_tag(:div, raw( localize(event.end_date, :format => :long)), :class => "end_date") if event.end_date

          # Venue
          venue = render_object(event.venue, :title, :description, :location_values, :link_url, :phone, :email)
          content << content_tag(:div, raw(venue), class: "venue")
        end
      end
      
      if event.is_root? && @article.eventmoduletype == "registration"
        @event_to_register = @article.event
        content << content_tag(:div, render(:partial => "goldencobra_events/events/register"), class: 'new_pricegroups')
      end
      
      unless event.is_root?
        unless event.has_children? #wir wollen nur bei den letzten Kinder-Events diese Infos anzeigen.
          if @article.eventmoduletype == "program"
            # Pricegroups
            pricegroup_items = ""
            event.event_pricegroups.available.each do |event_pricegroup|
              event_pricegroup_item = render_object(event_pricegroup, :pricegroup_id, :title)
              event_pricegroup_item << content_tag(:div, number_to_currency(event_pricegroup.price, :locale => :de), :class => "price")
              event_pricegroup_item << render_object(event_pricegroup, :number_of_participators_label, :cancelation_until, :start_reservation, :end_reservation)
              pricegroup_items << content_tag(:li, raw(event_pricegroup_item), class: "pricegroup_item_#{event_pricegroup.pricegroup_id} event_pricegroup_id_#{event_pricegroup.id}")
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
            content << content_tag(:ul, raw(artists_items), class: "artist_list")
          end
        end
      end

      if @article.eventmoduletype == "registration"
        if (event.needs_registration? || event.registration_optional?)
          c = content_tag(:div, raw(content), class: "article_event_content")

          # Sidebartext dient z.B. der Darstellung von Stornoinformationen
          # und wird unterhalb der Preisgruppen angezeigt
          c << content_tag(:div, raw(@article.context_info), class: "article_content_for_sidebar")

          return c
        else
          # if event.exclusive
          #   return content_tag(:div, raw(s("goldencobra_events.event.registration.exclusive_description")), class: "article_event_content exclusive_description")
          # else
            return content_tag(:div, "", class: "article_event_content")
          # end
        end
      else
          return content_tag(:div, raw(content), class: "article_event_content")
      end
    end

  end
end