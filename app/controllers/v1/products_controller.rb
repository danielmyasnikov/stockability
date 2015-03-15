class V1::ProductsController < V1::BaseController
  before_filter :find_product

  def update
    @product.update_attributes!(product_params)
    render json: { status: 'Ok', product: @product }
  rescue NoMethodError
    render json: { status: 'Product was not found' }, status: 404
  rescue ActiveRecord::RecordInvalid
    render json: 
      { status: 'Unprocessed entity', product: @product.errors }, status: 422
  end

private
  def find_product
    @product = Product.find_by_barcode(product_params[:barcode])
  end

  def product_params
    params.require(:product).permit(:barcode, :quantity)
  end
end
