class CreateTourEntries < ActiveRecord::Migration

  def change
    create_table :tour_entries do |t|
      t.references :tour
      t.integer :location
      t.string :bin
      t.string :sku
      t.string :barcode
      t.string :batch_code
      t.float :quantity
      t.boolean :active
      t.timestamps
    end
  end

end