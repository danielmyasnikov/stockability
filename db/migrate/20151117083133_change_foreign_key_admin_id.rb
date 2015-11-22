class ChangeForeignKeyAdminId < ActiveRecord::Migration
  def change
    rename_column :companies, :admin_id, :user_id
    rename_column :tours, :admin_id, :user_id
  end
end
