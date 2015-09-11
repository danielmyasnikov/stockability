class Company < ActiveRecord::Base
  has_many :admins
  has_many :bins
  has_many :products
  has_many :stock_levels
  has_many :tour_entries
  has_many :tours

  validates_presence_of :title

  validates_associated :admins
end
