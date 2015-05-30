class AddProductsToursTable < ActiveRecord::Migration
  def change
    create_table :products_tours do |t|
      t.integer :product_id
      t.integer :tour_id
    end
  end
end
