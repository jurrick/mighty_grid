require 'spec_helper'

describe MightyGrid do
  it 'setup block yields self' do
    MightyGrid.setup do |config|
      MightyGrid.should eq config
    end
  end

  it 'setup block configure Mighty Grid' do
    MightyGrid.setup do |config|
      MightyGrid.should eq config
    end

    MightyGrid.configured?.should be_true
  end
end
