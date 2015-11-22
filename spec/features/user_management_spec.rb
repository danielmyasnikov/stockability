require 'rails_helper'

feature 'Authentication' do

  given!(:admin_user)  { FactoryGirl.create(:user, :company_admin,
    :email => 'daniel.myasnikov@hotmail.com') }

  background do
    login_as(admin_user, scope: :user)
    visit '/users/products'
    click_link('Users')
  end

  scenario 'admin visits user management page and updates it' do
    click_link('New User')
    fill_in('Email', :with => 'test@stockability.com.au')
    fill_in('Login', :with => 'teststockabilitycomau')
    fill_in('Password', :with => 'teststockabilitycomau')
    click_on 'Create User'
    expect(page).to have_content('Succesfully created')
  end

end
