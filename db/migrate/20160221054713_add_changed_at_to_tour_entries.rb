class AddChangedAtToTourEntries < ActiveRecord::Migration
  def change
    add_column :tour_entries, :changed_at, :datetime
  end
end
