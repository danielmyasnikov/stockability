class Admin::AdminsController < Comfy::Admin::Cms::BaseController

  before_action :build_admin, :only => [:new, :create]
  before_action :load_admin,  :only => [:edit, :update, :destroy]

  def index
    @admins = Admind.all
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @admin.save!
    flash[:success] = 'Admin created'
    redirect_to :action => :edit, :id => @admin
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Admin'
    render :action => :new
  end

  def update
    @admin.update_attributes(admin_params)
    flash[:success] = 'Admin updated'
    redirect_to :action => :edit, :id => @admin
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Admin'
    render :action => :edit, :id => @admin
  end

  def destroy
  end

protected

  def build_admin
    @admin = Admin.new(admin_params)
    @admin.company = current_company unless current_admin.super_admin?
  end

  def load_admin
    @admin = Admin.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Admin not found'
    redirect_to :action => :index
  end

  def admin_params
    params.fetch(:admin, {}).permit(:email, :role, :company_id)
  end

end
