class Bin < ActiveRecord::Base
  # belongs_to :location
  belongs_to :location, foreign_key: :location_code, primary_key: :code
end
