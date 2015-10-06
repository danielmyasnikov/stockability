# --- Admins:
# SuperAdmin
# --- CLIENT
# Admin
# Manager
# Operator

class Ability
  include CanCan::Ability
  COMPANY_OBJ = [Location, Product, Tour, TourEntry, StockLevel, ProductBarcode]

  def initialize(user)
    alias_action :index, :show, to: :view
    alias_action :index, :show, :edit, :update, to: :touch

    cannot :manage, :all
    can [:view], Admin, :company_id => user.company_id

    case
    when user.super_admin?
      define_sa_ability
    when user.admin?
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

    can [:manage], Admin, :company_id => user.can_manage_admins?
    can [:manage], Company, :id => user.company_id
  end

  def define_manager_ability(user)
    COMPANY_OBJ.each do |_obj|
      can [:manage], _obj, :company_id => user.company_id
    end

    can [:manage], Admin, :company_id => user.can_manage_admins?
    can [:view], Company, :id => user.company_id
  end

  # read only access
  def define_operator_ability(user)
    operatable_obj = [Tour, TourEntry]
    managable_obj  = [Tour, TourEntry]

    operatable_obj.each do |_obj|
      can [:manage], _obj, :company_id => user.company_id
    end

    can [:manage], Admin, :company_id => user.can_manage_admins?

    managable_obj.each do |_obj|
      can [:view], _obj, :company_id => user.company_id
    end
  end
end
