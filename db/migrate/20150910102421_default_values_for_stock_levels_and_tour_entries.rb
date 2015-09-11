class DefaultValuesForStockLevelsAndTourEntries < ActiveRecord::Migration
  def change
    change_column :tour_entries, :quantity, :integer, :default => 1
    change_column :stock_levels, :quantity, :integer, :default => 1
    change_column :product_barcodes, :quantity, :integer, :default => 1
  end
end
