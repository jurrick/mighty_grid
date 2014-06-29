module MightyGrid
  module Controller
    protected

    attr_accessor :mighty_grid_instances

    def init_grid(klass, opts={})
      cg = MightyGrid::Base.new(klass, self, opts)
      self.mighty_grid_instances = [] if self.mighty_grid_instances.nil?
      self.mighty_grid_instances << cg
      cg
    end
  end
end