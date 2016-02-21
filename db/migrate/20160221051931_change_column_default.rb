class ChangeColumnDefault < ActiveRecord::Migration
  def change
    change_column :tour_entries, :quantity, :float, :default => 0.0
    change_column :stock_levels, :quantity, :float, :default => 0.0
  end
end
