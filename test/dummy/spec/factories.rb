require 'factory_girl'

Factory.define :article, :class => Goldencobra::Article do |u|
  u.title "Article Title"
  u.url_name "short-title"
  u.startpage false
  u.active true
  u.event_id nil
  u.event_levels 0
end

Factory.define :event, :class => GoldencobraEvents::Event do |u|
  u.title "Event Title"
  u.description "Dies ist eine Beschreibung"
  u.external_link "http://www.google.de"
  u.max_number_of_participators 12
  u.active true
  u.exclusive false
  u.ancestry ""
end

Factory.define :upload, :class => Goldencobra::Upload do |u|
  u.image_file_name "Bild1"
  u.description "Dies ist eine Beschreibung zu diesem Bild"
  u.source "Quelle1"
  u.rights "Alle Rechte vorhanden"
end

Factory.define :location, class: Goldencobra::Location do |l|
  l.street "Grunerstr. 1"
  l.city "Berlin"
  l.zip "12345"
  l.region "Berlin"
  l.country "Germany"
end

Factory.define:venue, class: GoldencobraEvents::Venue do |v|
  v.title "Kongresshalle"
  v.description "Eine Kongresshalle"
  v.link_url "http://www.kongresshalle.de"
  v.phone "(030) 123 456 77"
  v.email "info@kongresshalle.de"
end

Factory.define :pricegroup, :class => GoldencobraEvents::Pricegroup do |u|
  u.title "Gruppe"
end

Factory.define :event_pricegroup, :class => GoldencobraEvents::EventPricegroup do |u|
  u.event_id 1
  u.pricegroup_id 1
  u.price 50.0
  u.max_number_of_participators 500
  u.available true
end

Factory.define :panel, :class => GoldencobraEvents::Panel do |u|
  u.title "Naturstrom Panel"
  u.description "Das ist ein Panel"
  u.link_url "http://www.google.de"
end

Factory.define :sponsor, :class => GoldencobraEvents::Sponsor do |s|
  s.title "Naturstrom GmbH"
  s.description "Die Naturstrom GmbH ist ein tolles Unternehmen."
  s.link_url "http://www.naturstrom.de"
  s.size_of_sponsorship "Gold"
  s.type_of_sponsorship "Panel"
end

Factory.define :sponsor_image, class: GoldencobraEvents::SponsorImage do |si|
  si.sponsor_id 1
  si.image_id 2
end

Factory.define :event_sponsor, class: GoldencobraEvents::EventSponsor do |es|
  es.event_id 1
  es.sponsor_id 1
end

Factory.define :artist_event, class: GoldencobraEvents::ArtistEvent do |es|
  es.event_id 1
  es.artist 1
end

Factory.define :artist_image, class: GoldencobraEvents::ArtistImage do |ai|
  ai.artist_id 1
  ai.image_id 2
end

Factory.define :artist, :class => GoldencobraEvents::Artist do |a|
  a.title "Bodo Wartke"
  a.description "Ein Komiker"
  a.url_link "http://www.bodowartke.de"
  a.telephone "030 456 77 88"
  a.email "bodo@wartke.de"
end

Factory.define :menue, :class => Goldencobra::Menue do |u|
  u.title 'Nachrichten'
  u.target 'www.ikusei.de'
  u.active true
  u.css_class 'news'
end


Factory.define :admin_user, :class => User do |u|
  u.email 'admin@test.de'
  u.password 'secure12'
  u.password_confirmation 'secure12'
  u.confirmed_at "2012-01-09 14:28:58"
end

Factory.define :guest_user, :class => User do |u|
  u.email 'guest@test.de'
  u.password 'secure12'
  u.password_confirmation 'secure12'
end

Factory.define :startpage, :class => Goldencobra::Article do |u|
  u.title "Startseite"
  u.url_name "root"
  u.active true
end

Factory.define :role, :class => Goldencobra::Role do |r|
  r.name "admin"
end


Factory.define :admin_role, :class => Goldencobra::Role do |r|
  r.name "admin"
end

Factory.define :guest_role, :class => Goldencobra::Role do |r|
  r.name "guest"
end
