require 'spec_helper'

describe MightyGrid::Base do
  
  before(:all) do
    @controller = ActionView::TestCase::TestController.new

    @default_options = {page: 1, per_page: 15, name: 'grid'}
  end

  describe '#new' do
    context 'by default' do
      subject { MightyGrid::Base.new(Product, @controller) }
      its(:params) { should == {} }
      its(:options) { should == @default_options }
      its(:mg_params) { should == @default_options }
      its(:filters) { should == {} }
      its(:name) { should == 'grid' }
      its(:relation) { should == Product }
      its(:klass) { should == Product }
      its(:current_grid_params) { should == {} }
      its(:order_direction) { should == MightyGrid.config.order_direction }
      its(:filter_param_name) { should == 'f' }
      context 'controller' do
        it { instance_variable_get(:@controller).should == @controller }
      end
    end

    context 'with custom' do
      subject { MightyGrid::Base.new(Product, @controller, page: 2, per_page: 10, name: 'grid1') }
      its(:options) { should == {page: 2, per_page: 10, name: 'grid1'} }
    end

    context 'with custom' do
      before(:all){ @controller.params = {'grid' => {page: 5, per_page: 30, name: 'grid2'}} }
      subject { MightyGrid::Base.new(Product, @controller) }
      its(:params) { should == @controller.params }
      its(:mg_params) { should == {page: 5, per_page: 30, name: 'grid2'} }
      after(:all){ @controller.params = {} }
    end

    context 'with bad options' do
      it { expect{MightyGrid::Base.new(Product, @controller, bad_option: 123)}.to raise_error(ArgumentError) }
    end
  end

  describe '#get_current_grid_param' do
    before(:all){ @controller.params = {'grid'=>{per_page: 30}} }
    subject { MightyGrid::Base.new(Product, @controller).get_current_grid_param(:per_page) }
    it { should == 30 }
  end

end