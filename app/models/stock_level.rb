class StockLevel < ActiveRecord::Base

  # -- Relationships --------------------------------------------------------
  belongs_to :company
  # => this will fail if a different company will have a product with the same SKU
  belongs_to :product, foreign_key: :sku, primary_key: :sku
  belongs_to :location, foreign_key: :location_code, primary_key: :code
  belongs_to :bin, foreign_key: :bin_code, primary_key: :code
  # => do we need association between product barcodes and stocklevels

  # -- Callbacks ------------------------------------------------------------


  # -- Validations ----------------------------------------------------------
  validates :company_id, uniqueness: { scope: [:sku, :location_code, :bin_code] }

  # -- Scopes ---------------------------------------------------------------
  scope :since, -> (since) { since.present? ? where("updated_at > ?", since.to_datetime) : all }

  # -- Class Methods --------------------------------------------------------
  def self.sample
    CSV.generate do |csv|
      csv << ['sku', 'batch_code', 'quantity', 'bin_code', 'location_code']
      csv << %w(ALARM05  1 120 A01 SYD)
      csv << %w(BATCHA03  2 50  A01 SYD)
      csv << %w(BATCHA03  3 150 A02 SYD)
      csv << %w(BATCHA03  4 100 XYZ MEL)
    end
  end

  # -- Instance Methods -----------------------------------------------------

end
