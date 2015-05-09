class ApplicationController < ActionController::Base
  protect_from_forgery

protected
  def after_sign_in_path_for(resource)
    if resource.super_admin?
      admin_companies_path
    else
      admin_products_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path
  end
end
