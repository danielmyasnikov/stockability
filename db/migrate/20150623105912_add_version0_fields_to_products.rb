class AddVersion0FieldsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :sku, :string
    add_column :products, :description, :text
    add_column :products, :batch_tracked, :integer

    remove_column :products, :barcode, :string
    remove_column :products, :quantity, :integer
    remove_column :products, :session_id, :integer
  end
end
