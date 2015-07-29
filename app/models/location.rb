class Location < ActiveRecord::Base
  belongs_to :company
  has_many :bins
  validates_presence_of :code

  # does not assume if the code is upcase or downcase
  validates :code, uniqueness: { scope: [:company_id] }
end
