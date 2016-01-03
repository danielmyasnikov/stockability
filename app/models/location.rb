class Location < ActiveRecord::Base
  belongs_to :company
  has_many :stock_levels, -> (location) {
    where("locations.company_id = :company_id", company_id: location.company_id)
  }, foreign_key: :location_code, primary_key: :code
  validates_presence_of :code

  # does not assume if the code is upcase or downcase
  validates :code, uniqueness: { scope: [:company_id] }

  def option_title
    code + ' ' + name.to_s
  end
end
