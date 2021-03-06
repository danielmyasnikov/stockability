# --- Admins:
# SuperAdmin
# --- CLIENT
# Admin
# Manager
# Operator


# think through API, access level for managers / operators
class Ability
  include CanCan::Ability
  COMPANY_OBJ = [Location, Product, Tour, TourEntry, StockLevel, ProductBarcode]

  def initialize(user)
    alias_action :index, :show, to: :view
    alias_action :index, :show, :edit, :update, to: :touch

    cannot :manage, :all

    case
    when user.super_admin?
      define_sa_ability
    when user.company_admin?
      define_admin_ability(user)
    when user.warehouse_manager?
      define_manager_ability(user)
    when user.warehouse_operator?
      define_operator_ability(user)
    end
  end

private

  def define_sa_ability
    can :manage, :all
  end

  def define_admin_ability(user)
    COMPANY_OBJ.each do |_obj|
      can [:manage], _obj, :company_id => user.company_id
    end

    can [:manage], User, :company_id => user.company_id
    can [:manage], Company, :id => user.company_id
  end

  def define_manager_ability(user)
    COMPANY_OBJ.each do |_obj|
      can [:manage], _obj, :company_id => user.company_id
    end

    can [:manage], User, :id => user.id
    can [:view], User, :company_id => user.company_id
    can [:view], Company, :id => user.company_id
  end

  # read only access
  def define_operator_ability(user) 
    COMPANY_OBJ.each do |_obj|
      can :view, _obj, :company_id => user.company_id
    end
  end
end
