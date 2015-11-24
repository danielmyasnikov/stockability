class Users::AdminController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :except => [:new, :create]
  before_action :authorize_action

  def current_company
    current_user.company
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message

    redirect_to home_path_for(current_user)
  end

  def authorize_action
    unless current_ability.can?(action_name.to_sym, controller_name.camelcase.singularize.constantize)
      raise CanCan::AccessDenied 
    end
  end
end
