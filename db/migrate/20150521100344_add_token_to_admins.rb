class AddTokenToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :token, :string
  end
end
