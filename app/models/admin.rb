class Admin < ActiveRecord::Base
  belongs_to :company

  devise :database_authenticatable, :recoverable, :rememberable,
    :trackable, :validatable

  AVAILABLE_ROLES = [ :admin, :warehouse_manager, :warehouse_operator ].freeze
  ROLES           = [ :super_admin, AVAILABLE_ROLES ].flatten.freeze

  validates_presence_of :login, :company, :if => :requires_login?
  validates_uniqueness_of :login

  after_create :save_with_token

  ROLES.each do |_role|
    define_method("#{_role}?") do
      role == _role.to_s
    end
  end

  def can_manage_admins?
    super_admin? || admin?
  end

  def username
    case
    when self.to_s.present?
      self.to_s
    when login.present?
      login
    when email.present?
      email
    end
  end

  def self.options_for_select(user)
    roles = []
    if user.super_admin?
      ROLES.select do |role|
        roles.push [role.to_s.titleize, role]
      end
    else
      ROLES.select do |role|
        unless role == :super_admin
          roles.push [role.to_s.titleize, role]
        end
      end
    end
    roles
  end

  def to_s
    first_name.to_s + ' ' + last_name.to_s
  end

  def save_with_token; update_column(:token, generate_token); end

  def email_required?
    super_admin?
  end

private
  def generate_token
    SecureRandom.uuid
  end

  def requires_login?
    !super_admin?
  end
end
