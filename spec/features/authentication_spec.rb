require 'rails_helper'

feature 'Authentication' do

  given!(:site) { FactoryGirl.create(:site) }
  given!(:layout) { FactoryGirl.create(:layout) }

  given(:password)     { FFaker::Internet.password(8) }
  given!(:super_admin) { FactoryGirl.create(:admin, :super_admin,
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

      find('#login-button').click

      expect(current_path).to eq('/admin/companies')
    end

    scenario 'as a super admin, after successful login I see products index' do
      fill_in :admin_email, :with => member.email
      fill_in :admin_password, :with => password

      find('#login-button').click

      expect(current_path).to eq('/admin/products')
    end
  end

  context 'reset password' do

    background do
      find('a', :text => 'Forgot your password?').click
      fill_in :admin_email, :with => member.email
      first('input[type="submit"]').click

      open_email(member.email)
    end

    scenario 'as a user, I want to reset password' do
      current_email.click_link 'Change my password'
      expect(page).to have_content 'Change your password'
    end

    scenario 'display the correct text' do
      expect(current_email).to have_content "Hello #{member.email}"
    end
  end

  context 'unauthorized access' do
    scenario 'redirect to sign in page, when not logged in' do
      visit '/admin/companies'
      expect(page.body).to have_content 'You need to sign in or sign up before continuing'
    end
  end

end
