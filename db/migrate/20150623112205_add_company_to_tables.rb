class AddCompanyToTables < ActiveRecord::Migration
  def change
    add_column :stock_levels, :company_id, :integer
    add_column :tours, :company_id, :integer
    add_column :product_barcodes, :company_id, :integer
    add_column :locations, :company_id, :integer
  end
end
