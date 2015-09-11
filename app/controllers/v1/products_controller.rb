class V1::ProductsController < V1::BaseController

  load_and_authorize_resource :except => [:create]
  before_filter :find_product, only: [:destroy, :update, :show]
  before_action :initialize_product_service, :only => [:create, :update]

  api!
  desc 'Returns ALL accessible by a admin/manager/operator products'
  param :since, String, desc: 'Displays products since the date, eg "2015-08-04T10:24:35.729Z"'
  def index
    @products = Product.accessible_by(current_ability).since(since_params[:since])
    render json: @products
  end

  api!
  desc 'Returns a SINGLE product accessible by a admin/manager products'
  def show
    render json: @product
  end

  api!
  desc 'Creates a product according and product barcodes'
  param :product, Hash, required: true  do
    param :sku, String, required: true
    param :description, String
    param :batch_tracked, String
  end
  param :product_barcodes, Array do
    param :barcode, String, required: true
    param :quantity, String, required: true
    param :description, String
  end
  def create
    @product_service.create
    if @product_service.product_errors.empty? && @product_service.barcode_errors.empty?
      render json: { status: 'Ok', product: @product_service.obj_product }
    else
      render json: {
        status:         'Product was not saved',
        product_errors: @product_service.product_errors.map(&:to_s),
        barcode_errors: @product_service.barcode_errors.map(&:to_s)
      }, status: 422
    end
  end

  api!
  desc 'Updates a product found by database ID and product barcodes'
  param :product, Hash, required: true do
    param :sku, String
    param :description, String
    param :batch_tracked, String
  end
  param :product_barcodes, Array do
    param :barcode, String, required: true
    param :quantity, String, required: true
    param :description, String
  end
  def update
    @product_service.update
    render json: { status: 'Ok', product: @product_service.product }
  rescue Services::ProductBarcodesService::NotFound
    render json: { status: "Product was not found", sku: product_params[:product][:sku] }, status: 404
  rescue ActiveRecord::RecordInvalid
    render json:
      {
        status: 'Unprocessed entity',
        product_errors: @product_service.product_errors,
        barcode_errors: @product_service.barcode_errors
      }, status: 422
  end

  api!
  desc 'Deletes a product (by database ID) and product barcodes'
  def destroy
    @product.destroy
    render json: @product
  end

private
  def find_product
    @product = Product.find(params[:id])
  end

  def initialize_product_service
    @product_service = Services::ProductBarcodesService.new(
      :product          => product_params,
      :product_barcodes => barcode_params.fetch(:product_barcodes, []),
      :admin            => current_admin
    )
  end

  def product_params
    params.require(:product).permit(:sku, :description, :batch_tracked, :since)
  end

  def barcode_params
    params.permit(:product_barcodes => [:barcode, :quantity, :description])
  end

  def since_params
    params.permit(:since)
  end
end
