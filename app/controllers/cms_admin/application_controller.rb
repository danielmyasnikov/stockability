class CmsAdmin::ApplicationController < ApplicationController
  before_action :authenticate_admin!
  alias_method :current_user, :current_admin

  def current_company
    current_admin.company
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message

    redirect_to admin_company_path(current_admin.company_id)
  end
end
