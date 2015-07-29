class Bin < ActiveRecord::Base
  # FIXME: does not assume if the location_code is upcase or downcase
  # FIXME: does not assume if the location_code in the other company
  belongs_to :location, foreign_key: :location_code, primary_key: :code

  # TODO: how about location_id, does 1 bin belong to multiple locaitons?
  validates :code, uniqueness: { scope: [:company_id] }
end
