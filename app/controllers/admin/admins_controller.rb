class Admin::AdminsController < Comfy::Admin::Cms::BaseController

  before_action :build_admin, :only => [:new, :create]
  before_action :load_admin,  :only => [:edit, :update, :destroy]
  before_action :load_companies, :only => [:edit, :create, :new, :update]
  load_and_authorize_resource :except => [:new, :create]

  def index
    @admins = Admin.accessible_by(current_ability).page(params[:page])
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @admin.password_confirmation = admin_params[:password]
    @admin.company = current_company if current_company
    @admin.save!
    flash[:success] = 'Admin created'
    redirect_to :action => :edit, :id => @admin
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Admin'
    render :action => :new
  end

  def update
    @admin.update_without_password(admin_params)
    flash[:success] = 'Admin updated'
    redirect_to :action => :edit, :id => @admin
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Admin'
    render :action => :edit, :id => @admin
  end

  def destroy
    @admin.destroy
    flash[:success] = 'Admin user deleted'
    redirect_to :action => :index
  end

protected

  def build_admin
    @admin = Admin.new(admin_params)
  end

  def load_admin
    @admin = Admin.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Admin not found'
    redirect_to :action => :index
  end

  def admin_params
    params.fetch(:admin, {}).permit(:email, :role, :company_id, :password)
  end

  def load_companies
    @companies = Company.all.select(:id, :title)
  end

end
