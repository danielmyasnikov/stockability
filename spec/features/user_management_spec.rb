require 'rails_helper'

feature 'Authentication' do

  given!(:site) { FactoryGirl.create(:site) }
  given!(:layout) { FactoryGirl.create(:layout) }

  given!(:super_admin) { FactoryGirl.create(:admin, :super_admin) }
  given!(:member)      { FactoryGirl.create(:admin, :company_admin,
    :email => 'daniel.myasnikov@hotmail.com') }

  background do
    visit '/admins/sign_in'
  end

  scenario 'admin visits user management page and updates it' do

end
