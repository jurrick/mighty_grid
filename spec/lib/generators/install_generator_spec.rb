require 'spec_helper'
require 'generators/mighty_grid/install_generator'

require 'generator_spec'

describe MightyGrid::Generators::InstallGenerator do
  destination File.expand_path('../../tmp', __FILE__)

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates config initializer' do
    assert_file 'config/initializers/mighty_grid.rb'
  end

  it 'creates locale file' do
    assert_file 'config/locales/mighty_grid.en.yml'
  end

end
