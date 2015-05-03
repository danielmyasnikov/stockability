class Session < ActiveRecord::Base
  has_many :products
  def create_or_update_products(products_attr)
    products_attr.each do |product_attr|
      product = Product.find_or_initialize_by(:barcode =>
        product_attr[:barcode])

      product.quantity = product.quantity.to_i + product_attr[:quantity].to_i
      product.save!

      products << product
    end
  end
end
