class SuperAdmin < ActiveRecord::Base
  def super_admin?; true; end
end