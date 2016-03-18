require 'rails_helper'

feature 'Password Reset' do

  given!(:company_admin) { FactoryGirl.create(:user, :company_admin,
    :email => 'daniel.myasnikov@hotmail.com') }
  given!(:manager)      { FactoryGirl.create(:user, :warehouse_manager,
    :email => 'daniel.myasnikov+manager@hotmail.com') }
  given!(:operator)      { FactoryGirl.create(:user, :warehouse_operator,
    :email => 'daniel.myasnikov+operator@hotmail.com') }

  background do
    visit '/users/password/new'
  end

  context 'as a company admin' do
    scenario 'I expect to receive a password reset email with a link' do
      fill_in :user_email, :with => company_admin.email
      reset_password_for(company_admin)
      # see ApplicationController#redirect_path_for for more info
      expect(current_path).to eq(users_products_path)
    end
  end

  context 'as a warehouse_manager' do
    scenario 'I expect to receive a password reset email with a link' do
      fill_in :user_email, :with => manager.email
      reset_password_for(manager)
      # see ApplicationController#redirect_path_for for more info
      expect(current_path).to eq(users_products_path)
    end
  end
end

def reset_password_for(user)
  find('input[type="submit"]').click

  open_email(user.email)

  current_email.click_link 'Change my password'
  pass = FFaker::Internet.password(8)
  fill_in :user_password, with: pass
  fill_in :user_password_confirmation, with: pass

  find('input[type="submit"]').click
end
