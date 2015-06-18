class AddFieldsVersion0ToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :login ,      :string
    add_column :admins, :first_name , :string
    add_column :admins, :last_name ,  :string
  end
end
