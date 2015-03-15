module WarehouseCms::DeviseAuth
  def authenticate
    if current_admin
      ability = Ability.new(current_admin)
      return true if ability.can?(:manage, "Comfy::Cms::Site")
      raise CanCan::AccessDenied
    else
      scope = Devise::Mapping.find_scope!(:admin)
      session["#{scope}_return_to"] = new_comfy_admin_cms_site_path # if localized...
      redirect_to new_admin_session_path
    end
  end
end
