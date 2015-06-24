class CreateProductBarcodes < ActiveRecord::Migration

  def change
    create_table :product_barcodes do |t|
      t.string :barcode
      t.string :sku
      t.text :description
      t.float :quantity
      t.timestamps
    end
  end

end