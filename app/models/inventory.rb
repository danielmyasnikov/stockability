class Inventory < ActiveRecord::Base
  belongs_to :tour_entry
  belongs_to :stock_level
end
