class Admin < ActiveRecord::Base
  belongs_to :company

  devise :database_authenticatable, :recoverable, :rememberable,
    :trackable, :validatable

  AVAILABLE_ROLES = [ :admin, :warehouse_manager, :warehouse_operator ].freeze
  ROLES = [ :super_admin, AVAILABLE_ROLES ].flatten.freeze

  validates_presence_of :login, :company, :unless => :super_admin?

  after_create :save_with_token

  ROLES.each do |_role|
    define_method("#{_role}?") do
      role == _role.to_s
    end
  end

  def self.options_for_select
    roles = []
    ROLES.select do |role|
      roles.push [role.to_s.titleize, role]
    end
    roles
  end

  def save_with_token; update_column(:token, generate_token); end

  def email_required?
    super_admin?
  end

private
  def generate_token
    SecureRandom.uuid
  end
end
