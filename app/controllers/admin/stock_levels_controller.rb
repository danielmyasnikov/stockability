class Admin::StockLevelsController < Comfy::Admin::Cms::BaseController

  before_action :build_stock_level,  :only => [:new, :create]
  before_action :load_stock_level,   :only => [:show, :edit, :update, :destroy]

  after_action :save_import, only: :process_import
  before_action :read_import, only: :import
  after_action :forget_import, only: :import

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

  def import; end

  def process_import
    file      = params[:file]
    @importer = Services::StockLevelsImporter.new(file.tempfile, current_admin)
    @importer.import

    redirect_to action: :import
  end

  def sample
    respond_to do |format|
      format.csv { render text: StockLevel.sample }
    end
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

  def save_import
    Rails.cache.write(data_key, @importer)
  end

  def read_import
    @importer = Rails.cache.read(data_key)
    @results = @importer.try(:results) || []
  end

  def forget_import
    Rails.cache.write(data_key, nil)
  end

  def data_key
    "#{current_company.try(:id)}-importable-stock-levels"
  end
end
