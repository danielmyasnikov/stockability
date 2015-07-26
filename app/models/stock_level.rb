class StockLevel < ActiveRecord::Base

  # -- Relationships --------------------------------------------------------
  belongs_to :company
  # => this will fail if a different company will have a product with the same SKU
  belongs_to :product, foreign_key: :sku, primary_key: :sku
  belongs_to :location
  belongs_to :bin
  # do we need association between product barcodes and stocklevels

  # -- Callbacks ------------------------------------------------------------


  # -- Validations ----------------------------------------------------------
  validate :uniqueness

  # -- Scopes ---------------------------------------------------------------
  scope :since, -> (since) { since.present? ? where("updated_at > ?", since.to_datetime) : all }

  # -- Class Methods --------------------------------------------------------


  # -- Instance Methods -----------------------------------------------------

private

  def uniqueness
    # implement method based on composite key
  end

end
