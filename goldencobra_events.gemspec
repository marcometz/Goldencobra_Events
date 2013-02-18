$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "goldencobra_events/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "goldencobra_events"
  s.version     = GoldencobraEvents::VERSION
  s.authors     = ["Marco Metz"]
  s.email       = ["metz@ikusei.de"]
  s.homepage    = "http://www.goldencobra.de"
  s.summary     = "Summary of GoldencobraEvents."
  s.description = "Description of GoldencobraEvents."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["CC-LICENSE", "Rakefile", "README.markdown"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.11"
  s.add_dependency "goldencobra"
  s.add_dependency "goldencobra_email_templates"
  s.add_dependency "sass-rails"
  s.add_dependency "compass-rails"
  s.add_dependency "andand"
  s.add_dependency "pdfkit"
  s.add_dependency "wkhtmltopdf-binary"
  s.add_dependency "barby"
  # s.add_dependency 'pixelletter'
  s.add_dependency 'roadie'
  s.add_dependency 'uglifier', '>= 1.0.3'
  s.add_dependency 'mail'
  s.add_dependency 'sass'
  s.add_dependency 'coffee-rails'
  # s.add_dependency 'builder', '3.0.4'
  s.add_development_dependency "mysql2"
  s.add_development_dependency 'annotate'
  s.add_development_dependency 'guard-annotate'
  s.add_development_dependency 'pry'
end
