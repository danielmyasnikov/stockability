class Admin::ProductsController < Comfy::Admin::Cms::BaseController

  before_action :build_product,  :only => [:new, :create]
  load_and_authorize_resource :except => [:new, :create]

  after_action :save_import, only: :process_import
  before_action :read_import, only: :import
  after_action :forget_import, only: :import

  def index
    @products = Product.accessible_by(current_ability)
    respond_to do |format|
      format.html { render }
    end
  end

  def sample
    respond_to do |format|
      format.csv { render text: Product.sample }
    end
  end

  def download
    @products = Product.accessible_by(current_ability)
    respond_to do |format|
      format.csv { send_data Product.to_csv(@products), filename: "products-#{Date.today}.csv" }
    end
  end

  def import; end

  def process_import
    file      = params[:file]
    @importer = Services::ProductsBarcodesImporter.new(file.tempfile, current_admin)
    @importer.import

    redirect_to action: :import
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
    params.fetch(:product, {}).permit(:batch_tracked,
      :company_id, :sku, :description)
  end

  def save_import
    Rails.cache.write(data_key, @importer)
  end

  def read_import
    @importer = Rails.cache.read(data_key)
    @importer_results = @importer.try(:display_results) || []
  end

  def forget_import
    Rails.cache.write(data_key, nil)
  end

  def data_key
    "#{current_company.try(:id)}-importable-product-successfully_imported"
  end
end
