class DefaultValueForStockLevelQty < ActiveRecord::Migration
  def change
    change_column :tour_entries, :stock_level_qty, :float, :default => 0.0
  end
end
