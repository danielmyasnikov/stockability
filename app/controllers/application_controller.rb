class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    redirect_to home_path_for(current_user)
  end

  def current_ability
    if request.fullpath =~ /\/api\/v1/
      @current_ability ||= ApiAbility.new(current_user)
    else 
      @current_ability ||= Ability.new(current_user)
    end
  end

protected
  def after_sign_in_path_for(resource)
    home_path_for(current_user || current_admin_user)
  end

  def home_path_for(resource)
    if resource.super_admin?
      admin_users_path
    else
      users_products_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    '/'
  end
end
