class ChangeTourEntriesColumns < ActiveRecord::Migration
  def change
    rename_column :tour_entries, :bin_id, :bin_code
    change_column :tour_entries, :bin_code, :string
    rename_column :tour_entries, :location_id, :location_code
    change_column :tour_entries, :location_code, :string
  end
end
