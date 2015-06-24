class Product < ActiveRecord::Base

  has_and_belongs_to_many :tours
  belongs_to :company

  comma do
    name
  end

  def to_s
    "Name: #{name || 'N/A'}, Barcode: #{barcode}, Quantity: #{quantity.to_s}"
  end

end
