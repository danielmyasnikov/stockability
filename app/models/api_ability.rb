class ApiAbility
  include CanCan::Ability
  COMPANY_OBJ = [Location, Product, Tour, TourEntry, StockLevel, ProductBarcode]

  def initialize(user)
    alias_action :index, :show, to: :view
    alias_action :index, :show, :edit, :update, to: :touch

    cannot :manage, :all
    can [:view], Admin, :company_id => user.company_id

    case
    when user.company_admin? || user.warehouse_manager? || user.warehouse_operator?
      define_ability(user)
    end
  end

  def define_ability(user)
    COMPANY_OBJ.each do |_obj|
      can [:manage], _obj, :company_id => user.company_id
    end
  end
end