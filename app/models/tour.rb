class Tour < ActiveRecord::Base

  has_and_belongs_to_many :products
  belongs_to :admin

  comma do
    name
    created_at { |time| time.strftime("%Y %m %d - %H:%M") }

    admin :email
    products :size => 'Number of products scanned'
  end

  def create_or_update_products(products_attr)
    products_attr.each do |product_attr|
      product = Product.find_or_initialize_by(:barcode =>
        product_attr[:barcode])

      product.quantity = product.quantity.to_i + product_attr[:quantity].to_i
      product.save!

      products << product
    end
  end

  def to_csv
    _name = name || DateTime.now.strftime("%Y%m%d%H%M%S")
    CSV.generate do |csv|
      csv << ["Product Name", "Product Barcode", "Product Quantity"]
      products.each do |product|
        csv << [product.name, product.barcode, product.quantity]
      end
    end
  end
end