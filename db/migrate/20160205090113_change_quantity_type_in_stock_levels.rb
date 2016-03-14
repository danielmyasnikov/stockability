class ChangeQuantityTypeInStockLevels < ActiveRecord::Migration
  def change 
    change_column :tour_entries, :quantity, :float, :default => 1.0
    change_column :stock_levels, :quantity, :float, :default => 1.0
    change_column :product_barcodes, :quantity, :float, :default => 1.0
  end
end
