require 'rails_helper'

feature 'Authentication' do

  given!(:site) { FactoryGirl.create(:site) }
  given!(:layout) { FactoryGirl.create(:layout) }

  given!(:super_admin) { FactoryGirl.create(:admin, :super_admin) }
  given!(:admin_user)  { FactoryGirl.create(:admin, :company_admin,
    :email => 'daniel.myasnikov@hotmail.com') }

  background do
    login_as(admin_user, scope: :admin)
    visit '/admin/products'
    click_link('User Management')
  end

  scenario 'admin visits user management page and updates it' do
    click_link('New Admin')
    fill_in('Email', :with => 'test@stockability.com.au')
    fill_in('Login', :with => 'teststockabilitycomau')
    fill_in('Password', :with => 'teststockabilitycomau')
    click_on 'Create Admin'
    expect(page).to have_content('Succesfully created')
  end

end
