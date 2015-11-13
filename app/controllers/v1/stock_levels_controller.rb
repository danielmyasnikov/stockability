class V1::StockLevelsController < V1::BaseController
  load_and_authorize_resource except: [:create]
  before_filter :find_location, only: [:create]
  before_filter :find_or_create_product, only: [:create]

  api!
  desc "Returns ALL accessible by a admin/manager/operator stock levels
    GET /api/v1/stock_levels.json?auth[token]=c4c7-7e32
  "
  param :since, String, desc: 'Displays stock levels since the date, eg "2015-08-04T10:24:35.729Z"'
  def index
    @stock_levels = StockLevel.accessible_by(current_ability).since(since_params[:since])
    render json: { stock_levels: @stock_levels }
  end

  api!
  desc "Returns accessible by a admin/manager/operator stock level
    GET /api/v1/stock_levels/1.json?auth[token]=c4c7-7e32
  "
  def show
    render json: @stock_level
  end

  api!
  desc "Creates stock level item
    POST /api/v1/stock_levels.json?auth[token]=c4c7-7e32&stock_level[bin_code]=BIN001&stock_level[sku]=SKU001&stock_level[batch_code]=BATCH01&stock_level[quantity]=55&stock_level[location_code]=LOC001
  "
  param :stock_level, Hash, required: true do
    param :bin_code,      String
    param :sku,           String, required: true
    param :batch_code,    String
    param :quantity,      String
    param :location_code, String, required: true
  end
  def create
    if @location.try(:valid?) && @product.save
      @stock_level = StockLevel.create! stock_level_params.merge(company_params)
      render json: @stock_level
    else
      render json: { error: 'Location or Product are Invalid' }, status: 400
    end
  end

  api!
  desc "Updates stock level item
    PUT /api/v1/stock_levels/1.json?auth[token]=c4c7-7e32&stock_level[bin_code]=BIN001&stock_level[batch_code]=BATCH01&stock_level[quantity]=55
  "
  param :stock_level, Hash, required: true do
    param :bin_code,   String
    param :batch_code, String
    param :quantity,   String
  end
  def update
    @stock_level.update_attributes!(stock_level_update_params)
    render json: @stock_level
  end

  api!
  desc "Deletes a stock level
    DELETE /api/v1/stock_levels/1.json?auth[token]=c4c7-7e32
  "
  def destroy
    @stock_level.destroy
    render json: @stock_level
  end

private

  def since_params
    params.permit(:since)
  end

  def stock_level_params
    params.require(:stock_level).permit(:bin_code, :sku, :batch_code, :quantity, :location_code)
  end

  def stock_level_update_params
    params.require(:stock_level).permit(:bin_code, :batch_code, :quantity)
  end

  def location_params
    hash = {}
    hash = params.require(:stock_level).permit(:location_code)
    hash[:code] = hash.delete :location_code
    # company id should be always. or throw catch an exception, super admin creates the record
    hash[:company_id] = current_admin.company_id
    hash
  end

  def product_params
    params.require(:stock_level).permit(:sku)
  end

  def company_params
    { :company_id => current_admin.company_id }
  end

  def find_location
    @location = Location.find_by(location_params.merge(company_params))
  end

  def find_or_create_product
    @product = Product.find_or_initialize_by(product_params.merge(company_params))
  end
end
