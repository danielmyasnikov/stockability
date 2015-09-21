require 'rails_helper'

feature 'Authentication' do

  given!(:site)   { FactoryGirl.create(:site) }
  given!(:layout) { FactoryGirl.create(:layout) }

  given!(:client) { FactoryGirl.create(:admin, :company_admin,
    :email => 'daniel.myasnikov@hotmail.com') }

  given!(:location_1) { FactoryGirl.create(:location, :code => 'LOC001', :company_id => client.company_id) }
  given!(:location_2) { FactoryGirl.create(:location, :code => 'LOC002', :company_id => client.company_id) }

  given!(:prod_1) { FactoryGirl.create(:product, :sku => 'SKU001', :company_id => client.company_id) }
  given!(:prod_2) { FactoryGirl.create(:product, :sku => 'SKU002', :company_id => client.company_id) }

  given!(:stock_level_loc) {
    FactoryGirl.create(:stock_level,
      :company_id => client.company_id,
      :location_code => 'LOC001',
      :bin_code => 'BIN002',
      :sku => 'SKU002'
    )
  }

  given!(:stock_level_bin) {
    FactoryGirl.create(:stock_level,
      :company_id    => client.company_id,
      :location_code => 'LOC002',
      :bin_code      => 'BIN001',
      :sku           => 'SKU002'
    )
  }

  given!(:stock_level_prod) {
    FactoryGirl.create(:stock_level,
      :company_id     => client.company_id,
      :location_code  => 'LOC002',
      :bin_code       => 'BIN002',
      :sku            => 'SKU001'
    )
  }

  background do
    login_as(client, scope: :admin)
    visit '/admin/products'
    click_link('Stock Levels')
  end

  scenario 'filter by product SKU, bin code and location code' do
    expect(page).to have_content('LOC001')
    expect(page).to have_content('BIN002')
    expect(page).to have_content('SKU002')

  end

  context 'when filtering by SKU' do
    scenario 'filters results' do
      fill_in 'SKU', with: 'SKU001'
      expect(page).to     have_content('SKU001')
      expect(page).not_to have_content('SKU002')
    end
  end

  context 'when filtering by BIN CODE' do
    scenario 'filters results' do
      fill_in 'Bin Code', with: 'BIN001'
      expect(page).to     have_content('BIN001')
      expect(page).not_to have_content('BIN002')
    end
  end

  context 'when filtering by LOCATION CODE' do
    scenario 'filters results' do
      fill_in 'Location Code', with: 'LOC001'
      expect(page).to     have_content('LOC001')
      expect(page).not_to have_content('LOC002')
    end
  end

  context 'when selecting filtered results' do
    scenario 'filter stock levels and assign them to a new tour' do
      fill_in 'Location Code', with: 'LOC001'
      check('checkbox[value=' + stock_level_loc.id + ']')
      select('New tour', :from => 'tours')
      last_tour_id    = Tour.last.try(:id) || 0
      current_tour_id = last_tour_id + 1
      expect(page.path).to be('/admin/tours/' + current_tour_id + '/edit' )
      tour = Tour.find(current_tour_id)
      expect(tour.tour_entries).not_to eq(nil)
    end
  end
end
