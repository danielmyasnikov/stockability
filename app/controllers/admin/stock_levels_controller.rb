class Admin::StockLevelsController < Comfy::Admin::Cms::BaseController

  before_action :build_stock_level,  :only => [:new, :create]
  before_action :load_stock_level,   :only => [:show, :edit, :update, :destroy]

  def index
    @stock_levels = StockLevel.accessible_by(current_ability).page(params[:page])
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
    @stock_level.company = current_company if current_company
    @stock_level.save!
    flash[:success] = 'Stock Level created'
    redirect_to :action => :show, :id => @stock_level
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Stock Level'
    render :action => :new
  end

  def update
    @stock_level.update_attributes!(stock_level_params)
    flash[:success] = 'Stock Level updated'
    redirect_to :action => :show, :id => @stock_level
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Stock Level'
    render :action => :edit
  end

  def destroy
    @stock_level.destroy
    flash[:success] = 'Stock Level deleted'
    redirect_to :action => :index
  end

protected

  def build_stock_level
    @stock_level = StockLevel.new(stock_level_params)
  end

  def load_stock_level
    @stock_level = StockLevel.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Stock Level not found'
    redirect_to :action => :index
  end

  def stock_level_params
    params.fetch(:stock_level, {}).permit(:bin, :sku, :batch_code, :quantity)
  end
end
