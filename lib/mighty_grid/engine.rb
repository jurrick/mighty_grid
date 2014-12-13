module MightyGrid
  class Engine < ::Rails::Engine
    config.eager_load_namespaces << MightyGrid

    initializer 'mighty_grid.helpers' do |app|
      ActiveSupport.on_load :action_view do
        # It is here only until this pull request is pulled: https://github.com/amatsuda/kaminari/pull/267
        require 'mighty_grid/kaminari_monkey_patching'
      end
    end

    config.after_initialize do
      unless MightyGrid.configured?
        warn """
[Mighty Grid] Mighty Grid is not configured in the application and will use the default values.
Use `rails generate mighty_grid:install` to generate the Mighty Grid configuration.
        """
      end
    end
  end
end
