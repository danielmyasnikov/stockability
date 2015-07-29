class ChangeFields < ActiveRecord::Migration
  def change
    # add_column    :stock_levels, :location_id, :integer
    # rename_column :stock_levels, :bin, :bin_id
    # change_column :stock_levels, :bin_id, :integer
    rename_column :tour_entries, :location, :location_id
    TourEntry.all.each { |sl| sl.bin = sl.bin.to_i; sl.save! }
    rename_column :tour_entries, :bin, :bin_id
    change_column :tour_entries, :bin_id, 'integer USING CAST(bin_id as integer)'
  end
end
