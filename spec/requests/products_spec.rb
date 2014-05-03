require 'spec_helper'

feature 'Product' do
  background { 1.upto(100) {|i| Product.create! :name => "product#{'%03d' % i}" } }

  subject { page }

  describe "Index Page" do
    before { visit '/products' }

    it { should have_selector('table.mighty-grid') }
    it { should have_selector('ul.pagination') }
  end

end