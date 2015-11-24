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

  describe '#options_for_select' do
    it 'has access to all admin roles as company_admin' do
      company_admin = FactoryGirl.build(:user, :company_admin)
      opts = User.role_options_for_select(company_admin)
      expect(opts.map(&:second)).to eq(User.human_roles.keys)
    end

    it 'has access to 2 eq or lower roles as warehouse_manager' do
      admin = FactoryGirl.build(:user, :warehouse_manager)
      opts  = User.role_options_for_select(admin)
      expect(opts).to eq([
        ['Warehouse Manager', :warehouse_manager], 
        ['Warehouse Operator', :warehouse_operator]
      ])
    end
  end
end
