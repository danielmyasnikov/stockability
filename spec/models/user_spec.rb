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

  describe '#role_options_for_select' do
    it 'has access to all admin roles as company_admin' do
      role_opts   = User.role_options_for_select(:admin)
      human_roles = User.human_roles.to_a.map(&:reverse)
      expect(role_opts).to eq(human_roles)
    end

    it 'has access to 2 eq or lower roles as warehouse_manager' do
      opts  = User.role_options_for_select(:warehouse_manager)
      expect(opts).to eq([
        ['Warehouse Manager', :warehouse_manager], 
        ['Warehouse Operator', :warehouse_operator]
      ])
    end
  end
end
