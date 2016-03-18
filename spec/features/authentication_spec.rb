require 'rails_helper'

feature 'Authentication' do

  given!(:member) { FactoryGirl.create(:user, :company_admin,
    :email => 'daniel.myasnikov@hotmail.com') }

  background do
    visit '/users/sign_in'
  end

  context 'login' do

    scenario 'as a company admin, after successful login I see products index' do
      fill_in :user_email, :with => member.email
      fill_in :user_password, :with => 'password'

      find('#login-button').click

      expect(current_path).to eq('/users/products')
    end
  end

  context 'reset password' do

    background do
      find('a', :text => 'Forgot your password?').click
      fill_in :user_email, :with => member.email
      first('input[type="submit"]').click

      open_email(member.email)
    end

    scenario 'as a user, I want to reset password' do
      current_email.click_link 'Change my password'
      expect(page).to have_content 'Change Password'
    end

    scenario 'display the correct text' do
      expect(current_email).to have_content "Hello #{member.email}"
    end
  end

  context 'unauthorized access' do
    scenario 'redirect to sign in page, when not logged in' do
      visit '/users/companies'
      expect(page.body).to have_content 'You need to sign in or sign up before continuing'
    end
  end

end
