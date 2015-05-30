class ChnageTableNameFromInternalInspectionsToTours < ActiveRecord::Migration
  def change
    rename_table :internal_inspections, :tours
  end
end
