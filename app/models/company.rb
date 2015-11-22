class Company < ActiveRecord::Base
  has_many :users
  has_many :products
  has_many :stock_levels
  has_many :tour_entries
  has_many :tours

  validates_presence_of :title
end
