class Company < ActiveRecord::Base
  has_many :admins
  has_many :bins
  has_many :products

  validates_presence_of :title

  validates_associated :admins
end
