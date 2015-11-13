class RenameAdmins < ActiveRecord::Migration
  def change
    rename_table :admins, :users
  end
end
