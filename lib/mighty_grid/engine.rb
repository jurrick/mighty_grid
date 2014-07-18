module MightyGrid
  class MightyGridEngine < ::Rails::Engine
    initializer 'mighty_grid_railtie.configure_rails_initialization' do |app|

      ActiveSupport.on_load :action_controller do
        ActionController::Base.send(:include, MightyGrid::Controller)
      end

      ActiveSupport.on_load :action_view do
        ::ActionView::Base.class_eval { include MightyGrid::GridViewHelper }

        # It is here only until this pull request is pulled: https://github.com/amatsuda/kaminari/pull/267
        require 'mighty_grid/kaminari_monkey_patching'
      end

    end
  end
end
