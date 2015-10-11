class TourEntry < ActiveRecord::Base
  # -- Relationships --------------------------------------------------------
  has_many :stock_levels, through: :inventories
  has_many :inventories

  belongs_to :company
  belongs_to :tour

  # -- Callbacks ------------------------------------------------------------


  # -- Validations ----------------------------------------------------------


  # -- Scopes ---------------------------------------------------------------
  scope :since, -> (since) { since.present? ? where("updated_at > ?", since.to_datetime) : all }

  # -- Class Methods --------------------------------------------------------


  # -- Instance Methods -----------------------------------------------------
  def quantity=(value)
    if value.to_i > 0
      write_attribute(:quantity, value)
    else
      write_attribute(:quantity, 1)
    end
  end

end
