class AddVarianceToTourEntries < ActiveRecord::Migration
  def change
    add_column :tour_entries, :variance, :float
  end
end
