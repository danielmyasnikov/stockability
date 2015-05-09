class CmsAdmin::ApplicationController < ApplicationController
  before_action :authenticate_admin!

  def current_company
    current_admin.company
  end
end
