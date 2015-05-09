class Company < ActiveRecord::Base
  has_many :members
  has_many :bins
  has_many :products
end
