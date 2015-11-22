class Users::ProductBarcodesController < Users::AdminController

  before_action :build_product_barcode,  :only => [:new, :create]
  before_action :load_product_barcode,   :only => [:show, :edit, :update, :destroy]
  before_action :load_barcode_relationships, :only => [:new, :edit, :update, :create]

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
    @product_barcode.company = current_company if current_company
    @product_barcode.save!
    flash[:success] = 'Product Barcodes created'
    redirect_to :action => :show, :id => @product_barcode
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Product Barcodes'
    render :action => :new
  end

  def update
    @product_barcode.update_attributes!(product_barcode_params)
    flash[:success] = 'Product Barcodes updated'
    redirect_to :action => :show, :id => @product_barcode
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Product Barcodes'
    render :action => :edit
  end

  def destroy
    @product_barcode.destroy
    flash[:success] = 'Product Barcodes deleted'
    redirect_to :action => :index
  end

protected

  def build_product_barcode
    @product_barcode = ProductBarcode.new(product_barcode_params)
  end

  def load_product_barcode
    @product_barcode = ProductBarcode.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Product Barcodes not found'
    redirect_to :action => :index
  end

  def product_barcode_params
    params.fetch(:product_barcode, {}).permit(:barcode, :sku, :description, :quantity)
  end

  def load_barcode_relationships
    @sku = Product.accessible_by(current_ability).pluck(:sku)
  end
end
