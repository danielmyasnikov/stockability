class Admin::ProductsController < Comfy::Admin::Cms::BaseController

  before_action :build_product,  :only => [:new, :create]
  load_and_authorize_resource :except => [:new, :create]

  def index
    @products = Product.accessible_by(current_ability).page(params[:page])
    respond_to do |format|
      format.html { render }
      format.csv { render :csv => Product.accessible_by(current_ability) }
    end
  end

  def sample
    respond_to do |format|
      format.csv { render :csv => sample_file }
    end
  end

  def import
    @errors = Rails.cache.read("#{current_company.id}-importable-product-errors")
  end

  def process_import
    file = params[:file]
    @importer = Services::ProductsBarcodesImporter.new(file.tempfile, current_admin)
    @importer.import

    if @importer.errors
      Rails.cache.write("#{current_company.id}-importable-product-errors", @importer.errors)
      redirect_to action: :import, :flash => { :errors => @importer.errors }
    else
      flash[:success] = 'Successfully imported'
      redirect_to action: :import
    end
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
    @product.company = current_company if current_company
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

  # def load_product
  #   @product = Product.find(params[:id])
  # rescue ActiveRecord::RecordNotFound
  #   flash[:danger] = 'Product not found'
  #   redirect_to :action => :index
  # end

  def product_params
    params.fetch(:product, {}).permit(:name, :batch_tracked,
      :company_id, :sku, :description)
  end

  def sample_file
    CSV.generate do |row|
      row << ['sku', 'barcode']
      row << ['123sku', '12barcode']
    end
  end
end
