class AddStockLevelIdToTourEntries < ActiveRecord::Migration
  def change
    add_column :tour_entries, :stock_level_id, :integer
  end
end
