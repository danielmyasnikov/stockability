class AddStockLevelQtyToTourEntries < ActiveRecord::Migration
  def change
    add_column :tour_entries, :stock_level_qty, :float, default: 1
  end
end
