class ApplicationController < ActionController::Base
  alias_method :current_user, :current_admin
  protect_from_forgery

  def index
    redirect_to home_path_for(resource)
  end

protected
  def after_sign_in_path_for(resource)
    home_path_for(resource)
  end

  def after_sign_out_path_for(resource_or_scope)
    '/'
  end
end
