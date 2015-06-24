require 'rails_helper'

RSpec.describe Admin, :type => :model do

  let(:super_admin) { FactoryGirl.build(:admin, :super_admin) }
  let(:admin)       { FactoryGirl.build(:admin, :company_admin) }

  context 'when an admin is member' do
    subject { admin.save! }

    it 'does not throw an exception if admin does not have an email' do
      expect { subject }.not_to raise_error
    end

    it 'throws an exception if it does not have a login' do
      admin.login = nil
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid,
        "Validation failed: Login can't be blank")
    end
  end

  context 'when an admin is super admin' do
    subject { super_admin.save! }

    it 'saved admin with a secret token' do
      expect(super_admin.token).to eq(nil)
      super_admin.email = FFaker::Internet.email
      subject
      expect(super_admin.token).not_to eq(nil)
    end

    it 'does require an email' do
      super_admin.email = nil
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid,
        "Validation failed: Email can't be blank")
    end
  end

end
