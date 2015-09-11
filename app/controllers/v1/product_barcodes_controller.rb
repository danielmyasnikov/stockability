class V1::ProductBarcodesController < V1::BaseController
  load_and_authorize_resource :except => [:create]

  api!
  desc 'Returns ALL accessible by a user product_barcodes'
  param :since, String, desc: 'Displays product_barcodes since the date, eg "2015-08-04T10:24:35.729Z"'
  def index
    @product_barcodes = ProductBarcode.accessible_by(current_ability).since(since_params)
    render json: @product_barcodes
  end

  api!
  desc 'Returns a SINGLE product_barcode entry accessible by a user product_barcode'
  def show
    render json: @product_barcode
  end

  api!
  desc 'Creates product_barcode entry item'
  param :product_barcode, Hash, required: true do
    param :sku,         String, required: true
    param :barcode,     String, required: true
    param :description, String
    param :quantity,    String
  end
  def create
    @product_barcode = ProductBarcode.create!(product_barcode_create_params.merge(company_params))
    render json: @product_barcode
  end

  api!
  desc 'Creates product_barcode entry item'
  param :product_barcode, Hash, required: true do
    param :quantity,    String
    param :description, String
  end
  def update
    @product_barcode.update_attributes!(product_barcode_create_params)
    render json: @product_barcode
  end

  api!
  desc 'Deletes a product_barcode entry (by database ID)'
  def destroy
    @product_barcode.destroy
    render json: @product_barcode
  end

protected

  def product_barcode_create_params
    params.require(:product_barcode).permit(:sku, :barcode,
      :description, :quantity)
  end

  def product_barcode_update_params
    params.require(:product_barcode).permit(:id, :description, :quantity)
  end
end
