require 'spec_helper'

describe MightyGrid::Column do

  describe '#new' do
    describe 'with attribute' do
      context 'without options' do
        subject { MightyGrid::Column.new(:name) }
        context 'parameters' do
          its(:attribute) { should == :name }
          its(:render_value) { should == :name }
          its(:title) { should == '' }
          its(:attrs) { should == {} }
          its(:th_attrs) { should == {} }
        end
      end

      context 'with html option' do
        let(:options) { {html: {class: 'column'}} }
        subject { MightyGrid::Column.new(:name, options) }
        its(:options) { should == options }
        its(:attrs) { should == options[:html] }
      end

      context 'with title option' do
        let(:options) { {title: 'Name'} }
        subject { MightyGrid::Column.new(:name, options) }
        its(:options) { should == options }
        its(:title) { should == options[:title] }
      end

      context 'with th_html option' do
        let(:options) { {th_html: {class: 'active'}} }
        subject { MightyGrid::Column.new(:name, options) }
        its(:options) { should == options }
        its(:th_attrs) { should == {class: 'active'} }
      end
    end

    describe 'with block' do
      context 'without options' do
        subject { MightyGrid::Column.new {:test} }
        context 'parameters' do
          its(:attribute) { should == nil }
          its(:title) { should == '' }
          its(:render_value) { should be_an_instance_of Proc }
          its(:attrs) { should == {} }
          its(:th_attrs) { should == {} }
        end
      end
    end
  end

  describe '.render' do
    let(:user){ User.create(name: 'user name') }

    describe 'with attribute' do
      subject(:column){ MightyGrid::Column.new(:name) }
      it 'should return attribute value' do
        column.render(user).should == user[:name]
      end
    end

    describe 'with block' do
      subject(:column){ MightyGrid::Column.new { "#{user.name} 1" } }
      it 'should return attribute value' do
        column.render(user).should == "#{user[:name]} 1"
      end
    end
  end

end