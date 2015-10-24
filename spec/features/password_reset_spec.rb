require 'rails_helper'

feature 'Password Reset' do

  given!(:site) { FactoryGirl.create(:site) }
  given!(:layout) { FactoryGirl.create(:layout) }

  given!(:super_admin) { FactoryGirl.create(:admin, :super_admin) }
  given!(:company_admin) { FactoryGirl.create(:admin, :company_admin,
    :email => 'daniel.myasnikov@hotmail.com') }
  given!(:manager)      { FactoryGirl.create(:admin, :warehouse_manager,
    :email => 'daniel.myasnikov+manager@hotmail.com') }
  given!(:operator)      { FactoryGirl.create(:admin, :warehouse_operator,
    :email => 'daniel.myasnikov+operator@hotmail.com') }

  background do
    visit '/admins/password/new'
  end

  context 'as a super admin' do
    scenario 'I expect to see companies page on successful password reset' do
      fill_in :admin_email, :with => super_admin.email
      reset_password_for(super_admin)
      expect(current_path).to eq(admin_companies_path)
    end
  end

  context 'as a company admin' do
    scenario 'I expect to receive a password reset email with a link' do
      fill_in :admin_email, :with => company_admin.email
      reset_password_for(company_admin)
      # see ApplicationController#redirect_path_for for more info
      expect(current_path).to eq(admin_products_path)
    end
  end

  context 'as a warehouse_manager' do
    scenario 'I expect to receive a password reset email with a link' do
      fill_in :admin_email, :with => manager.email
      reset_password_for(manager)
      # see ApplicationController#redirect_path_for for more info
      expect(current_path).to eq(admin_products_path)
    end
  end

  context 'as a warehouse_manager' do
    scenario 'not sure what to expect from warehouse managers role atm...'
  end
end

def reset_password_for(user)
  find('input[type="submit"]').click

  open_email(user.email)

  current_email.click_link 'Change my password'
  pass = FFaker::Internet.password(8)
  fill_in :admin_password, with: pass
  fill_in :admin_password_confirmation, with: pass

  find('input[type="submit"]').click
end
