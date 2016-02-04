class AddVisibleToTourEntries < ActiveRecord::Migration
  def change
    add_column :tour_entries, :visible, :boolean, :default => true
  end
end
