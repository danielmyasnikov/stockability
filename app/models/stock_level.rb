class StockLevel < ActiveRecord::Base
  include Sequel::SearchHelpers

  # -- Relationships --------------------------------------------------------
  belongs_to :company

  belongs_to :product, -> (stock_level) {
    where("products.company_id = :company_id", company_id: stock_level.company_id)
  }, foreign_key: :sku, primary_key: :sku

  belongs_to :location, -> (stock_level) {
    where("locations.company_id = :company_id", company_id: stock_level.company_id)
  }, foreign_key: :location_code, primary_key: :code

  has_many :tour_entries
  # => do we need association between product barcodes and stocklevels

  # -- Callbacks ------------------------------------------------------------
  
  # -- Scopes ---------------------------------------------------------------
  scope :since, -> (since) { since.present? ? where("updated_at > ?", since.to_datetime) : all }

  # -- Class Methods --------------------------------------------------------
  def self.composite_key
    [:sku, :location_code, :bin_code, :batch_code]
  end

  def self.find_by_entry(tour_entry)
    attrs = entry.attributes.slice(*StockLevel.composite_key.map!(&:to_s))
    where(attrs).first
  end
  
  def self.sample
    require 'csv'
    CSV.generate do |csv|
      csv << ['sku', 'batch_code', 'quantity', 'bin_code', 'location_code']
      csv << %w(ALARM05  1 120 A01 SYD)
      csv << %w(BATCHA03  2 50  A01 SYD)
      csv << %w(BATCHA03  3 150 A02 SYD)
      csv << %w(BATCHA03  4 100 XYZ MEL)
    end
  end

  def self.to_csv(stock_levels)
    CSV.generate do |csv|
      csv << %w(sku location_code bin_code batch_code quantity product_description)
      stock_levels.each do |sl|
        csv << [sl.sku, sl.location_code, sl.bin_code, sl.batch_code, sl.quantity, sl.product.try(:description)]
      end
    end
  end

  # -- Validations ----------------------------------------------------------
  validates :company_id, uniqueness: { scope: composite_key, message: 'Record is not unique' }
  validates_presence_of :sku, :location_code


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

  def last_tours
    tour_entries.order('created_at DESC').map(&:tour).take(3)
  end
end
