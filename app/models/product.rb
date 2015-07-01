class Product < ActiveRecord::Base
  # remove product name
  has_and_belongs_to_many :tours
  belongs_to :company

  # validates on 1 company 1 sku
  validates_uniqueness_of :sku
  has_many :product_barcodes, foreign_key: :sku, primary_key: :sku

  scope :since, -> (since) {
    if since
      where("updated_at > ?", since.to_datetime)
    else
      all
    end
  }

  comma do
    name
  end

  def to_s
    "Name: #{name || 'N/A'}, Barcode: #{barcode}, Quantity: #{quantity.to_s}"
  end

end
