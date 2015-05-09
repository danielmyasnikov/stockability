require 'rails_helper'

feature 'Authentication' do

  given(:password)     { FFaker::Internet.password }
  given!(:super_admin) { FactoryGirl.create(:admin, :super,
    :password => password) }
  given!(:member)      { FactoryGirl.create(:admin, :member,
    :password => password) }

  background do
    visit '/admins/sign_in'
  end

  context 'login' do
    scenario 'as a super admin, after successful login I see companies index' do
      fill_in :admin_email, :with => super_admin.email
      fill_in :admin_password, :with => password

      expect(page.body).to have_selector('h1', :text => 'Companies')
    end

    scenario 'as a super admin, after successful login I see products index' do
      fill_in :admin_email, :with => member.email
      fill_in :admin_password, :with => password

      expect(page.body).to have_selector('h1', :text => 'Products')
    end
  end

  context 'reset password' do

    background do
      find('a', :text => 'Forgot your password?').click
      fill_in :member_email, :with => member.email
      first('input[type="submit"]').click

      open_email(member.email)
    end

    scenario 'as a user, I want to reset password' do
      current_email.click_link 'Change my password'
      expect(page).to have_content 'Change Your Password'
    end

    scenario 'display the correct text' do
      expect(current_email).to have_content "Hello #{member.email}"
    end
  end

  context 'unauthorized access' do
    scenario 'redirect to sign in page, when not logged in' do
      visit '/admins/companies'
      expect(page.body).to have_selector(:li, :text => 'You are not authorized. Please login.')
    end
  end

end
