class Admin::ProductBarcodesController < Comfy::Admin::Cms::BaseController

  before_action :build_product_barcodes,  :only => [:new, :create]
  before_action :load_product_barcodes,   :only => [:show, :edit, :update, :destroy]

  def index
    @product_barcodes = ProductBarcode.accessible_by(current_ability) #.page(params[:page])
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
    @product_barcodes.company = current_company if current_company
    @product_barcodes.save!
    flash[:success] = 'Product Barcodes created'
    redirect_to :action => :show, :id => @product_barcodes
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Product Barcodes'
    render :action => :new
  end

  def update
    @product_barcodes.update_attributes!(product_barcodes_params)
    flash[:success] = 'Product Barcodes updated'
    redirect_to :action => :show, :id => @product_barcodes
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Product Barcodes'
    render :action => :edit
  end

  def destroy
    @product_barcodes.destroy
    flash[:success] = 'Product Barcodes deleted'
    redirect_to :action => :index
  end

protected

  def build_product_barcodes
    @product_barcodes = ProductBarcode.new(product_barcodes_params)
  end

  def load_product_barcodes
    @product_barcodes = ProductBarcode.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Product Barcodes not found'
    redirect_to :action => :index
  end

  def product_barcodes_params
    params.fetch(:product_barcode, {}).permit(:barcode, :sku, :description, :quantity)
  end

  def company_params
    { :company_id => @admin.company_id }
  end
end
