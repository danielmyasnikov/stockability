class TourEntry < ActiveRecord::Base
  belongs_to :company
  belongs_to :tour
  belongs_to :location
  belongs_to :bin

  # -- Relationships --------------------------------------------------------


  # -- Callbacks ------------------------------------------------------------


  # -- Validations ----------------------------------------------------------


  # -- Scopes ---------------------------------------------------------------
  scope :since, -> (since) { since.present? ? where("updated_at > ?", since.to_datetime) : all }

  # -- Class Methods --------------------------------------------------------


  # -- Instance Methods -----------------------------------------------------


end
