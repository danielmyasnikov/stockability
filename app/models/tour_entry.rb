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
    attributes.slice(*self.composite_key.map!(&:to_s))
  end

  def variance
    entry.sum_quantity - stock_level_qty
  end

  def blind_stock_count?
    stock_level_id.nil?
  end

  def non_blind_stock_count?
    !blind_stock_count?   
  end

  def quantity=(value)
    if value.to_f > 0
      write_attribute(:quantity, value)
    else
      write_attribute(:quantity, 1)
    end
  end

  private

  def variance_change_required?
    quantity_changed? || stock_level_qty_changed?
  end

end
