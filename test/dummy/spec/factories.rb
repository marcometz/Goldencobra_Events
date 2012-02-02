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
end


Factory.define :pricegroup, :class => GoldencobraEvents::Pricegroup do |u|
  u.title "Gruppe"
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