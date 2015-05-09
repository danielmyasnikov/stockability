class Admin::BinsController < Comfy::Admin::Cms::BaseController

  before_action :build_bin,  :only => [:new, :create]
  before_action :load_bin,   :only => [:show, :edit, :update, :destroy]

  def index
    @bins = Bin.page(params[:page])
  end

  def show
    render
  end

  def new
    render
  end

  def edit
    render
  end

  def create
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