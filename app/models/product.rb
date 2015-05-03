class Product < ActiveRecord::Base

  belongs_to :sessions

  validate :validate_quantity

  # -- Relationships --------------------------------------------------------


  # -- Callbacks ------------------------------------------------------------


  # -- Validations ----------------------------------------------------------


  # -- Scopes ---------------------------------------------------------------


  # -- Class Methods --------------------------------------------------------


  # -- Instance Methods -----------------------------------------------------

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