class TourEntry < ActiveRecord::Base
  # -- Relationships --------------------------------------------------------
  has_many :stock_levels, through: :inventories
  has_many :inventories, dependent: :destroy

  belongs_to :company
  belongs_to :tour

  # something is wrong when executing save in console??..
  after_save :calculate_variance

  # -- Callbacks ------------------------------------------------------------


  # -- Validations ----------------------------------------------------------


  # -- Scopes ---------------------------------------------------------------
  scope :since, -> (since) { since.present? ? where("updated_at > ?", since.to_datetime) : all }
  scope :only_variance, -> (only_variance) { only_variance ? where('variance <> 0') : all }

  # -- Class Methods --------------------------------------------------------

  # -- Instance Methods -----------------------------------------------------
  def quantity=(value)
    if value.to_f > 0
      write_attribute(:quantity, value)
    else
      write_attribute(:quantity, 1)
    end
  end

  def calculate_variance
    update_column(:variance, quantity - stock_level_qty) if stock_level_changed?
  end

  def stock_level_changed?
    (quantity - stock_level_qty) != 0
  end

end
