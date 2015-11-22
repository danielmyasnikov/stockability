class Users::AdminController < ApplicationController
  before_action :authenticate_user!

  def current_company
    current_user.company
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message

    redirect_to users_company_path(current_user.company_id)
  end
end
