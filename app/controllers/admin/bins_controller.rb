class Admin::BinsController < Comfy::Admin::Cms::BaseController

  before_action :build_bin,  :only => [:new, :create]
  load_and_authorize_resource :except => [:new, :create]

  def index
    @bins = Bin.accessible_by(current_ability).page(params[:page])
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @bin.company = current_company if current_company
    @bin.save!
    flash[:success] = 'Bin created'
    redirect_to :action => :show, :id => @bin
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Bin'
    render :action => :new
  end

  def update
    @bin.update_attributes!(bin_params)
    flash[:success] = 'Bin updated'
    redirect_to :action => :show, :id => @bin
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Bin'
    render :action => :edit
  end

  def destroy
    @bin.destroy
    flash[:success] = 'Bin deleted'
    redirect_to :action => :index
  end

protected

  def authorize_content
    authorize! params[:action].to_sym, @bin
  end

  def build_bin
    @bin = Bin.new(bin_params)
  end

  def load_bin
    @bin = Bin.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Bin not found'
    redirect_to :action => :index
  end

  def bin_params
    params.fetch(:bin, {}).permit(:title, :location, :company)
  end
end
