require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:admin)       { FactoryGirl.build(:user, :warehouse_operator) }

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
end
