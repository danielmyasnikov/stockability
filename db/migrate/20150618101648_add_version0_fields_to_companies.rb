class AddVersion0FieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :admin_id, :integer
    add_column :companies, :email, :string
    add_column :companies, :web, :string
    add_column :companies, :address2, :string
    add_column :companies, :address3, :string
    add_column :companies, :country, :string

    remove_column :companies, :acn, :string
  end
end
