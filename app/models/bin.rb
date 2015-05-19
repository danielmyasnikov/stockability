class Bin < ActiveRecord::Base
  belongs_to :company

  scope :mine, -> (company_id) { where(:company_id => company_id) }

  validates_presence_of :title, :location
end
