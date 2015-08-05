class TourEntry < ActiveRecord::Base
  belongs_to :company
  belongs_to :tour
  belongs_to :location, foreign_key: :location_code, primary_key: :code
  belongs_to :bin, foreign_key: :bin_code, primary_key: :code

  # -- Relationships --------------------------------------------------------


  # -- Callbacks ------------------------------------------------------------


  # -- Validations ----------------------------------------------------------


  # -- Scopes ---------------------------------------------------------------
  scope :since, -> (since) { since.present? ? where("updated_at > ?", since.to_datetime) : all }

  # -- Class Methods --------------------------------------------------------


  # -- Instance Methods -----------------------------------------------------


end
