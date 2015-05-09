class Product < ActiveRecord::Base

  belongs_to :sessions
  belongs_to :company

  validate :validate_quantity

  def to_s
    "Name: #{name}, Barcode: #{barcode}, Quantity: #{quantity.to_s}"
  end

private

  def validate_quantity
    unless quantity.to_i > 0
      errors.add(:invalid_quantity, "can't be less than 0")
    end
  end
end
