class Location < ActiveRecord::Base
  belongs_to :company
  validates_presence_of :code

end
