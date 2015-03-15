class ApplicationController < ActionController::Base
  protect_from_forgery

  # before_action :authenticate_member!
protected
  def after_sign_in_path_for(resource)
    admin_products_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path
  end
end
