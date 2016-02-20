class TourEntry < ActiveRecord::Base
  # -- Relationships --------------------------------------------------------
  belongs_to :company
  belongs_to :tour
  belongs_to :stock_level

  after_create :calculate_variance
  after_save :calculate_variance, :if => :variance_change_required?

  # -- Callbacks ------------------------------------------------------------


  # -- Validations ----------------------------------------------------------


  # -- Scopes ---------------------------------------------------------------
  scope :since, -> (since) { since.present? ? where("updated_at > ?", since.to_datetime) : all }
  scope :only_variance, -> (only_variance) { only_variance ? where('variance <> 0') : all }
  scope :aggregated, -> { select(
    'sum(variance) as sum_variance, sum(quantity) as sum_quantity, sum(stock_level_qty) as sum_stock_level_qty').
     group('tour_id, location_code, bin_code, sku, barcode, tours.company_id, tour_name, tours.id, tour_entries.id')
  }

  # -- Class Methods --------------------------------------------------------

  # -- Instance Methods -----------------------------------------------------

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

  def calculate_variance
    update_column(:variance, quantity - stock_level_qty)
  end

  def adjust_variance
    stock_level.update_attributes(quantity: stock_level.quantity + variance)
    update_column(:stock_level_qty, stock_level_qty + variance)
    update_column(:variance, 0)
    update_column(:visible, false)
  end

  def reject_variance
    update_column(:quantity, stock_level_qty)
    update_column(:variance, 0)
    update_column(:visible, false)
  end

  private

  def variance_change_required?
    quantity_changed? || stock_level_qty_changed?
  end

end
