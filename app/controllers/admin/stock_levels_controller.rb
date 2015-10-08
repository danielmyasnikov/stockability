class Admin::StockLevelsController < Comfy::Admin::Cms::BaseController

  before_action :build_stock_level,  :only => [:new, :create]
  before_action :load_stock_level,   :only => [:show, :edit, :update, :destroy]
  before_action :select_options, :only => [:index]
  before_action :compact_select_options, :only => [:index]
  before_action :load_tours, :only => [:index]
  after_action :save_processed_records, only: :process_stock_levels

  after_action :save_import, only: :process_import
  before_action :read_import, only: :import
  after_action :forget_import, only: :import

  def index
    @stock_levels = StockLevel.accessible_by(current_ability).where(search_params)
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
    # this is weak solution
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

  def process_stock_levels
    @processor = Services::StockLevelsProcessor.new(stock_levels_params, params[:tour])
    @processor.process

    if @processor.errors.blank?
      render json: { redirect_required: is_redirect_required? }
    else
      render json: { redirect_required: is_redirect_required?,
        errors: @processor.errors }, status: 422
    end
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
    params.fetch(:stock_level, {}).permit(:bin_code, :sku, :batch_code, :quantity)
  end

  def stock_levels_params
    params[:stock_levels]
  end

  def save_import
    Rails.cache.write(data_key, @importer)
  end

  def read_import
    @importer = Rails.cache.read(data_key)
    @results = Services::StockLevelsImporter.results
  end

  def forget_import
    Rails.cache.write(data_key, nil)
    Services::StockLevelsImporter.nullify_results
  end

  def save_processed_records
    Rails.cache.write(data_key, @processor)
  end

  def read_proceesed_records
    @processor = Rails.cache.read(data_key)
    # Services::StockLevelsProcessor.nullify_results
    Rails.cache.write(data_key, nil)
  end

  def data_key
    "#{current_company.try(:id)}-stock-levels"
  end

  def select_options
    s_levels = StockLevel.accessible_by(current_ability).select(:sku, :location_code, :bin_code)

    @sku_options      = s_levels.map { |opt| [opt.sku, opt.sku] }
    @location_options = s_levels.map { |opt| [opt.location_code, opt.location_code] }
    @bin_options      = s_levels.map { |opt| [opt.bin_code, opt.bin_code] }
  end

  def compact_select_options
    [@bin_options, @location_options, @sku_options].map do |x|
      x.uniq!
      x.delete_if  { |x| x == [nil, nil] }
    end
  end

  def search_params
    search = params.permit(:bin_code, :location_code, :sku)
    search.delete_if { |k, v| v.empty? } # what if value for one of columns is searchable nil?
    @search_params = search.each { |k, v| search[k] = v.split(',') }
  end

  def load_tours
    tours = Tour.accessible_by(current_ability).select(:name, :id)
    @tour_options = tours.map { |opt| [opt.name, opt.id] }
    @tour_options.push(['! - Create New Tour', 'NEWTOUR'])
  end

  def is_redirect_required?
    params[:tour] == 'NEWTOUR'
  end
end
