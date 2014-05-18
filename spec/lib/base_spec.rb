require 'spec_helper'

describe MightyGrid::Base do
  
  before(:all) do
    @controller = ActionView::TestCase::TestController.new

    @default_options = {page: 1, per_page: 15, name: 'grid', :include => nil, joins: nil}
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
      its(:current_order_direction) { should == nil }
      its(:another_order_direction) { should == 'asc' }
      its(:filter_param_name) { should == 'f' }
      context 'controller' do
        it { instance_variable_get(:@controller).should be_an_instance_of ActionView::TestCase::TestController }
      end
    end

    context 'with custom' do
      subject { MightyGrid::Base.new(Product, @controller, page: 2, per_page: 10, name: 'grid1') }
      its(:options) { should == @default_options.merge(page: 2, per_page: 10, name: 'grid1') }
    end

    context 'with custom' do
      before(:all){ @controller.params = {'grid' => {page: 5, per_page: 30, name: 'grid2'}} }
      subject { MightyGrid::Base.new(Product, @controller) }
      its(:params) { should == @controller.params }
      its(:mg_params) { should == @default_options.merge(page: 5, per_page: 30, name: 'grid2') }
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
    after(:all){ @controller.params = {} }
  end

  describe '#current_order_direction' do
    context 'with ASC controller param' do
      before(:all){ @controller.params = {'grid'=>{'order_direction' => 'asc'}} }
      subject { MightyGrid::Base.new(Product, @controller) }
      its(:current_order_direction) { should == 'asc' }
      after(:all){ @controller.params = {} }
    end

    context 'with DESC controller param' do
      before(:all){ @controller.params = {'grid'=>{'order_direction' => 'desc'}} }
      subject { MightyGrid::Base.new(Product, @controller) }
      its(:current_order_direction) { should == 'desc' }
      after(:all){ @controller.params = {} }
    end

    context 'with BAD controller param' do
      before(:all){ @controller.params = {'grid'=>{'order_direction' => 'bad'}} }
      subject { MightyGrid::Base.new(Product, @controller) }
      its(:current_order_direction) { should == nil }
      after(:all){ @controller.params = {} }
    end
  end

  describe '#another_order_direction' do
    context 'with ASC controller param' do
      before(:all){ @controller.params = {'grid'=>{'order_direction' => 'asc'}} }
      subject { MightyGrid::Base.new(Product, @controller) }
      its(:another_order_direction) { should == 'desc' }
      after(:all){ @controller.params = {} }
    end

    context 'with DESC controller param' do
      before(:all){ @controller.params = {'grid'=>{'order_direction' => 'desc'}} }
      subject { MightyGrid::Base.new(Product, @controller) }
      its(:another_order_direction) { should == 'asc' }
      after(:all){ @controller.params = {} }
    end

    context 'with BAD controller param' do
      before(:all){ @controller.params = {'grid'=>{'order_direction' => 'bad'}} }
      subject { MightyGrid::Base.new(Product, @controller) }
      its(:another_order_direction) { should == 'asc' }
      after(:all){ @controller.params = {} }
    end
  end

  describe '#order_params' do
    before(:all){ @controller.params = {'grid'=>{'order' => 'name', 'order_direction' => 'asc'}} }
    subject { MightyGrid::Base.new(Product, @controller) }
    context 'with current order attribute' do
      it { subject.order_params(:name).should == {'grid'=>{order: :name, order_direction: 'desc'}} }
    end
    context 'with other order attribute' do
      it { subject.order_params(:description).should == {'grid'=>{order: :description, order_direction: 'asc'}} }
    end
    after(:all){ @controller.params = {} }
  end

  describe '#like_operator' do
    subject { MightyGrid::Base.new(Product, @controller) }
    context "when DB is #{ENV['DB']}" do
      case ENV['DB']
        when 'postgresql'
          it{ subject.like_operator.should == 'ILIKE' }
        when 'sqlite', 'mysql'
          it{ subject.like_operator.should == 'LIKE' }
      end
    end
  end

end