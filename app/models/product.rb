class Product < ActiveRecord::Base

  has_and_belongs_to_many :tours
  belongs_to :company

  validate :validate_quantity

  validates_presence_of :barcode

  def to_s
    "Name: #{name || 'N/A'}, Barcode: #{barcode}, Quantity: #{quantity.to_s}"
  end

private

  def validate_quantity
    unless quantity.to_i > 0
      errors.add(:invalid_quantity, "can't be less than 0")
    end
  end
end
