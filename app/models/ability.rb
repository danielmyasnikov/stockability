# SA => SuperAdmin
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
    when user.member?
      define_member_ability(user)
    end
  end

  def define_sa_ability
    can :manage, :all
  end

  def define_member_ability(user)
    company_obj = [Bin, Product, Admin]

    company_obj.each do |_obj|
      can [:manage], _obj, :company_id => user.company_id
    end

    can [:view], Tour, :products => { :company_id => user.company_id }

    can [:view], Company, :id => user.company_id
  end
end
