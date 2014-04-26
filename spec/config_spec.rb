require 'spec_helper'

describe MightyGrid::Configuration do
  subject { MightyGrid.config }

  describe 'per_page' do
    context 'by default' do
      its(:per_page) { should == 15 }
    end
    context 'configured via config block' do
      before { MightyGrid.configure {|c| c.per_page = 17} }
      its(:per_page) { should == 17 }
      after { MightyGrid.configure {|c| c.per_page = 15} }
    end
  end

  describe 'order_direction' do
    context 'by default' do
      its(:order_direction) { should == 'asc' }
    end
    context 'configured via config block' do
      before { MightyGrid.configure {|c| c.order_direction = 'desc'} }
      its(:order_direction) { should == 'desc' }
      after { MightyGrid.configure {|c| c.order_direction = 'asc'} }
    end
  end

  describe 'grid_name' do
    context 'by default' do
      its(:grid_name) { should == 'grid' }
    end
    context 'configured via config block' do
      before { MightyGrid.configure {|c| c.grid_name = 'g1'} }
      its(:grid_name) { should == 'g1' }
      after { MightyGrid.configure {|c| c.grid_name = 'grid'} }
    end
  end

  describe 'table_class' do
    context 'by default' do
      its(:table_class) { should == '' }
    end
    context 'configured via config block' do
      before { MightyGrid.configure {|c| c.table_class = 'table'} }
      its(:table_class) { should == 'table' }
      after { MightyGrid.configure {|c| c.table_class = ''} }
    end
  end

  describe 'header_tr_class' do
    context 'by default' do
      its(:header_tr_class) { should == '' }
    end
    context 'configured via config block' do
      before { MightyGrid.configure {|c| c.header_tr_class = 'active'} }
      its(:header_tr_class) { should == 'active' }
      after { MightyGrid.configure {|c| c.header_tr_class = ''} }
    end
  end

  describe 'pagination_template' do
    context 'by default' do
      its(:pagination_theme) { should == 'mighty_grid' }
    end
    context 'configured via config block' do
      before { MightyGrid.configure {|c| c.pagination_theme = 'pagination1'} }
      its(:pagination_theme) { should == 'pagination1' }
      after { MightyGrid.configure {|c| c.pagination_theme = 'mighty_grid'} }
    end
  end
end