class RemoveVarianceFromTourEntries < ActiveRecord::Migration
  def change
    remove_column :tour_entries, :variance
  end
end
