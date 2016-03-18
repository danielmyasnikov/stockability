class TourEntry < ActiveRecord::Base
  include StockAbility::QueryMethods::TourEntries

  # -- Relationships --------------------------------------------------------
  belongs_to :company
  belongs_to :tour
  belongs_to :stock_level

  # -- Callbacks ------------------------------------------------------------


  # -- Validations ----------------------------------------------------------


  # -- Scopes ---------------------------------------------------------------
  scope :visible, -> { where(:visible => true) }
  scope :hidden, -> { where(:visible => false) }

  scope :since, -> (since) { since.present? ? where("updated_at > ?", since.to_datetime) : all }
  scope :only_variance, -> (only_variance) { only_variance ? where('variance <> 0') : all }
  # -- Class Methods --------------------------------------------------------
  def self.composite_key
    StockLevel.composite_key.push(:tour_id)
  end

  # -- Instance Methods -----------------------------------------------------
  def composite_key_attributes
    {
      tour_id:       tour_id,
      sku:           sku,
      location_code: location_code,
      bin_code:      bin_code,
      batch_code:    batch_code
    }
  end

  def variance
    sum_quantity - stock_level_qty
  end

  def quantity=(value)
    if value.nil?
      write_attribute(:quantity, 1)
    else
      write_attribute(:quantity, value)
    end
  end

  private

  def variance_change_required?
    quantity_changed? || stock_level_qty_changed?
  end

end
