require 'rails/generators'

module MightyGrid
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      desc 'Copies MightyGrid configuration and locale files to your application.'

      def copy_config_file
        template 'mighty_grid.rb', 'config/initializers/mighty_grid.rb'
      end

      def copy_locale_file
        copy_file '../../../../config/locales/en.yml', 'config/locales/mighty_grid.en.yml'
      end
    end
  end
end
