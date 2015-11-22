class ChangeColumnTypeBatchTrackedToBoolean < ActiveRecord::Migration
  def change
    change_column :products, :batch_tracked, 'boolean USING CAST(batch_tracked as boolean)'
  end
end
