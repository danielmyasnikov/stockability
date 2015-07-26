class V1::StockLevelsController < V1::BaseController
  load_and_authorize_resource except: [:create]

  api!
  desc 'Returns ALL accessible by a admin/manager/operator stock levels'
  param :since, String, desc: 'Displays stock levels since the date, eg "14-july-2015"'
  def index
    @stock_levels = StockLevel.accessible_by(current_ability).since(since_params[:since])
    render json: @stock_levels
  end

  def show
    render json: @stock_level
  end

  api!
  desc 'Creates stock level item'
  param :stock_level, Hash, required: true do
    param :bin_id,      String
    param :sku,         String
    param :batch_code,  String
    param :quantity,    String
    param :location_id, String
  end
  def create
    @stock_level = StockLevel.create!(stock_level_params.merge(company_params))
    render json: @stock_level
  end

  api!
  desc 'Updates stock level item'
  param :stock_level, Hash, required: true do
    param :bin_id,      String
    param :sku,         String
    param :batch_code,  String
    param :quantity,    String
    param :location_id, String
  end
  def update
    @stock_level.update_attributes!(stock_level_params)
    render json: @stock_level
  end

  api!
  desc 'Deletes a stock level (by database ID)'
  def destroy
    @stock_level.destroy
    render json: @stock_level
  end

private

  def since_params
    params.permit(:since)
  end

  def stock_level_params
    params.require(:stock_level).permit(:bin_id, :sku, :batch_code, :quantity, :location_id)
  end

  def company_params
    { :company_id => current_admin.company_id }
  end
end
