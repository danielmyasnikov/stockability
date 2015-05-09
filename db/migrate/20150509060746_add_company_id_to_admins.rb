class AddCompanyIdToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :company_id, :integer
  end
end
