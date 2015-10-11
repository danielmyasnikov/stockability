class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories, id: false do |t|
      t.references :tour_entry, index: true
      t.references :stock_level, index: true
    end
  end
end
