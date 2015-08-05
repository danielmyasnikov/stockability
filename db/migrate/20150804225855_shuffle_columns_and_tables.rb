class ShuffleColumnsAndTables < ActiveRecord::Migration
  def change
    drop_table :bins
  end
end
