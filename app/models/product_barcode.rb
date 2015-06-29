class ProductBarcode < ActiveRecord::Base
  belongs_to :company
  belongs_to :product, foreign_key: :sku, primary_key: :sku
end
