class ChangeLocationCode < ActiveRecord::Migration
  def change
    add_column    :bins, :location_id, :integer
    rename_column :bins, :location, :location_code
  end
end
