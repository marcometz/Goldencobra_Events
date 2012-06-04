require 'securerandom'

module GoldencobraEvents
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("..templates", __FILE__)

      desc "Extend the Goldencobra-ActiveAdmin-Initializer, add a route, copy locales to application."
      class_option :orm

      def extend_initializer
        insert_into_file "config/initializers/active_admin.rb", "config.load_paths << '#{GoldencobraEvents::Engine.root}/admin/'", :after => 'config.load_paths << "#{Goldencobra::Engine.root}/admin/"\n'
      end
    end
  end
end
