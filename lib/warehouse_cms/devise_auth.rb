module WarehouseCms::DeviseAuth
  def authenticate
    if current_admin
      return true
    else
      scope = Devise::Mapping.find_scope!(:admin)
      session["#{scope}_return_to"] = new_comfy_admin_cms_site_path # if localized...
      redirect_to new_admin_session_path
    end
  end
end
