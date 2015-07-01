class V1::ProductsController < V1::BaseController
  before_filter :find_product, except: [:index, :create]

  before_action :build_product, :only => [:create]
  load_and_authorize_resource :except => [:create]

  api!
  desc 'Returns ALL accessible by a admin/manager products'
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
    param :product_barcodes, Array do
      param :barcode, String, required: true
      param :quantity, String, required: true
      param :description, String
    end
  end
  def create
    if @product_service.save
      render json: { status: 'Ok', product: @product_service.product }
    else
      render json: { status: 'Product was not saved', errors: @product_service.errors },
        status: 422
    end
  end

  api!
  desc 'Updates a product found by database ID and product barcodes'
  param :product, Hash, required: true do
    param :sku, String
    param :description, String
    param :batch_tracked, String
    param :product_barcodes, Array do
      param :barcode, String, required: true
      param :quantity, String, required: true
      param :description, String
    end
  end
  def update
    @product_service = Services::ProductBarcodesService.find(@product)
    @product_service.update_attributes(product_params, barcode_params)
    render json: { status: 'Ok', product: @product_service.product }
  rescue Services::ProductBarcodesService::NotFound
    render json: { status: "Product was not found", sku: product_params[:product][:sku] }, status: 404
  rescue ActiveRecord::RecordInvalid
    render json:
      { status: 'Unprocessed entity', product: @product.errors }, status: 422
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

  def build_product
    product          = Product.new product_params
    @product_service = Services::ProductBarcodesService.new(product, barcode_params, current_admin)
  end

  def product_params
    params.require(:product).permit(:sku, :description, :batch_tracked, :since)
  end

  def barcode_params
    params.require(:product).permit(:product_barcodes => [:barcode, :quantity, :description])
  end

  def since_params
    params.permit(:since)
  end
end
