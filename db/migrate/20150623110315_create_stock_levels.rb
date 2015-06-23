class CreateStockLevels < ActiveRecord::Migration

  def change
    create_table :stock_levels do |t|
      t.string :bin
      t.string :sku
      t.string :batch_code
      t.float :quantity
      t.timestamps
    end
  end

end