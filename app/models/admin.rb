class Admin < ActiveRecord::Base
  belongs_to :company

  devise :database_authenticatable, :recoverable, :rememberable,
    :trackable, :validatable

  AVAILABLE_ROLES = [ :member ].freeze
  ROLES = [ :super_admin, AVAILABLE_ROLES ].flatten.freeze


  validates_presence_of :company, :unless => :super_admin?

  ROLES.each do |_role|
    define_method("#{_role}?") do
      role == _role.to_s
    end
  end
end
