class AddAdminIdToTours < ActiveRecord::Migration
  def change
    add_column :tours, :admin_id, :integer
  end
end
