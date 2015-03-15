class Admin::ProductsController < Comfy::Admin::Cms::BaseController

  before_action :build_product,  :only => [:new, :create]
  before_action :load_product,   :only => [:show, :edit, :update, :destroy]

  def index
    @products = Product.page(params[:page])
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
    @product.save!
    flash[:success] = 'Product created'
    redirect_to :action => :show, :id => @product
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Product'
    render :action => :new
  end

  def update
    @product.update_attributes!(product_params)
    flash[:success] = 'Product updated'
    redirect_to :action => :show, :id => @product
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Product'
    render :action => :edit
  end

  def destroy
    @product.destroy
    flash[:success] = 'Product deleted'
    redirect_to :action => :index
  end

protected

  def build_product
    @product = Product.new(product_params)
  end

  def load_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Product not found'
    redirect_to :action => :index
  end

  def product_params
    params.fetch(:product, {}).permit(:name, :barcode, :quantity)
  end
end