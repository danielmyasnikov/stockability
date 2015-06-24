# --- Admins:
# SuperAdmin
# --- CLIENT
# Admin
# Manager
# Operator

class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :index, :show, to: :view
    alias_action :index, :show, :edit, :update, to: :touch

    cannot :manage, :all

    case
    when user.super_admin?
      define_sa_ability
    when user.admin?
      define_admin_ability(user)
    when user.warehouse_manager?
      define_manager_ability(user)
    end
  end

  def define_sa_ability
    can :manage, :all
  end

  def define_admin_ability(user)
    company_obj = [Product, Admin, Tour, TourEntry, StockLevel, ProductBarcode]

    company_obj.each do |_obj|
      can [:manage], _obj, :company_id => user.company_id
    end

    can [:view], Company, :id => user.company_id
  end

  def define_manager_ability(user)
    company_obj = [Product, Admin, Tour, TourEntry, StockLevel, ProductBarcode]

    company_obj.each do |_obj|
      can [:view], _obj, :company_id => user.company_id
    end

    can [:view], Company, :id => user.company_id
  end
end
