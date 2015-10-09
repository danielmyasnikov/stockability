class StockLevel < ActiveRecord::Base

  # -- Relationships --------------------------------------------------------
  belongs_to :company

  belongs_to :product, -> (stock_level) {
    where("products.company_id = :company_id", company_id: stock_level.company_id)
  }, foreign_key: :sku, primary_key: :sku

  belongs_to :location, -> (stock_level) {
    where("locations.company_id = :company_id", company_id: stock_level.company_id)
  }, foreign_key: :location_code, primary_key: :code
  # => do we need association between product barcodes and stocklevels

  # -- Callbacks ------------------------------------------------------------


  # -- Validations ----------------------------------------------------------
  validates :company_id, uniqueness: { scope: [:sku, :location_code, :bin_code, :batch_code], message: 'Record is not unique' }
  validates_presence_of :sku, :location_code

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
  def quantity=(value)
    if value.to_i > 0
      write_attribute(:quantity, value)
    else
      write_attribute(:quantity, 1)
    end
  end

  def associated_with_tour_entry?
    false # fill in a logic on how to associate the records
  end
end
