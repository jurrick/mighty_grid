require 'spec_helper'

require "generator_spec"

describe MightyGrid::Generators::ConfigGenerator do
  destination File.expand_path("../../tmp", __FILE__)

  before(:all) do
    prepare_destination
    run_generator
  end

  it "creates config initializer" do
    assert_file "config/initializers/mighty_grid_config.rb"
  end
end