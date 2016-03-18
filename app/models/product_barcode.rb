class ProductBarcode < ActiveRecord::Base
  belongs_to :company
  # => this will fail if a different company will have a product with the same SKU
  # TO DO
  belongs_to :product, foreign_key: :sku, primary_key: :sku

  validates_presence_of :quantity

  scope :since, -> (since) { since.present? ? where("updated_at > ?", since.to_datetime) : all }

  # def quantity=(value)
  #   if value.to_i > 0
  #     write_attribute(:quantity, value)
  #   else
  #     write_attribute(:quantity, 1)
  #   end
  # end
end
