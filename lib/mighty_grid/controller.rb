module MightyGrid
  module Controller
    protected

    attr_accessor :mighty_grid_instances

    def init_grid(klass, opts = {})
      cg = MightyGrid::Base.new(klass, self, opts)
      @mighty_grid_instances = [] if @mighty_grid_instances.nil?
      @mighty_grid_instances << cg
      cg
    end
  end
end

ActiveSupport.on_load :action_controller do
  include MightyGrid::Controller
end
