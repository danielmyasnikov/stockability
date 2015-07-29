class ChangeStockLevelsColumns < ActiveRecord::Migration
  def change
    add_column :stock_levels, :location_id, :integer

    StockLevel.all.each { |sl| sl.bin = sl.bin.to_i; sl.save! }
    rename_column :stock_levels, :bin, :bin_id
    change_column :stock_levels, :bin_id, 'integer USING CAST(bin_id as integer)'
  end
end
