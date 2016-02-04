class User < ActiveRecord::Base
  belongs_to :company

  devise :database_authenticatable, :recoverable, :rememberable,
    :trackable, :validatable

  ROLES = [ :admin, :warehouse_manager, :warehouse_operator ].freeze

  validates_presence_of :login, :company, :if => :requires_login?
  validates_presence_of :role

  validates_uniqueness_of :login

  after_create :save_with_token

  ROLES.each do |_role|
    define_method("#{_role}?") do
      role == _role.to_s
    end
  end

  def can_manage_admins?; company_admin?; end
  def company_admin?; admin?; end

  def self.human_roles
    h = Hash.new({})

    ROLES.map do |role|
      h[role] = role.to_s.titleize
    end
    h
  end

  def username
    case
    when self.to_s.present?
      self.to_s
    when self.login.present?
      self.login
    when email.present?
      email
    end
  end

  def self.role_options_for_select(user_role)
    roles = []
    ROLES.each_with_index do |_role, index|
      next if index < ROLES.index(user_role.to_sym)
      roles.push([_role.to_s.titleize, _role])
    end
    roles
  end

  def to_s
    first_name.to_s + ' ' + last_name.to_s
  end

  def update_me(params)
    if password_params?(params)
      update_with_password(params)
    else
      update_without_password(params)
    end
  end

  def save_with_token; update_column(:token, generate_token); end
  def email_required?; company_admin?; end
  def super_admin?; false; end

private

  def generate_token; SecureRandom.uuid; end
  def requires_login?; !email_required? end

  def generate_token
    SecureRandom.uuid
  end

  def requires_login?
    !super_admin?
  end

  def password_params?(params)
    params[:password].present? && params[:password_confirmation].present?
  end
end
