require 'spec_helper'

feature 'Product' do
  background { 1.upto(100) {|i| Product.create! :name => "product#{'%03d' % i}" } }

  subject { page }

  describe 'Index Page' do
    before { visit '/products' }

    it { should have_selector 'form.mighty-grid-filter' }
    it { should have_selector 'table.mighty-grid' }
    it { should have_selector 'ul.pagination' }
  end

  scenario 'filtering by fields' do
    visit '/products'

    product_name = Product.first.name
    
    within '.mighty-grid-filter' do
      fill_in "grid_f_name", :with => product_name
    end

    click_button "Apply changes"

    expect(page).to have_content product_name
    expect(page).to have_content '1 of 1'
  end

end