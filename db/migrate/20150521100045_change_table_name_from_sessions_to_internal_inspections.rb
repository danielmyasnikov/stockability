class ChangeTableNameFromSessionsToInternalInspections < ActiveRecord::Migration
  def change
    rename_table :sessions, :internal_inspections
  end
end
