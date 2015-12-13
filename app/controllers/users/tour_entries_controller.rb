class Users::TourEntriesController < Users::AdminController

  before_action :build_tour_entry,  :only => [:new, :create]
  before_action :load_tour_entry,   :only => [:show, :edit, :update, :destroy]
  before_action :load_tour_relationships, :only => [:new, :create, :edit, :update]
  before_action :load_tour_entries, :only => [:index, :apply_variance, :reject_variance]

  def index
    # NEW TOUR OPTION
    @tour_options = Tour.accessible_by(current_ability)
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

  def apply_variance
    # PERFORMANCE optimized solution
    # @tour_entries.pluck(:id, :quantity).each do |te|
    #   # for performance reasons using update_all as it doesn't initialize object
    #   TourEntry.where(:id => te.first).update_all(stock_level_qty: te.second)
    # end

    # CALLBACK optimized solution
    @tour_entries.pluck(:id, :stock_level_qty, :variance).each do |te|
      qty = te.second + te.third
      TourEntry.find(te.first).update_attributes(stock_level_qty: qty, quantity: qty)
    end
    redirect_to :back
  end

  def reject_variance
    # PERFORMANCE optimized solution
    # @tour_entries.pluck(:id, :stock_level_qty).each! do |te|
    #   # for performance reasons using update_all as it doesn't initialize object
    #   TourEntry.where(:id => te.first).update_all(quantity: te.second)
    # end
    # redirect_to :index

    # CALLBACK solution
    @tour_entries.pluck(:id, :stock_level_qty).each do |te|
      # for performance reasons using update_all as it doesn't initialize object
      TourEntry.find(te.first).update_attribute(:quantity, te.second)
    end
    redirect_to :back
  end

  def create
    @tour_entry.company = current_company if current_company
    @tour_entry.save!
    flash[:success] = 'Tour Entry created'
    redirect_to :action => :show, :id => @tour_entry
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Tour Entry'
    render :action => :new
  end

  def update
    @tour_entry.update_attributes!(tour_entry_params)
    flash[:success] = 'Tour Entry updated'
    redirect_to :action => :show, :id => @tour_entry
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Tour Entry'
    render :action => :edit
  end

  def destroy
    @tour_entry.destroy
    flash[:success] = 'Tour Entry deleted'
    redirect_to :action => :index
  end

protected

  def build_tour_entry
    @tour_entry = TourEntry.new(tour_entry_params)
  end

  def load_tour_entry
    @tour_entry = TourEntry.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Tour Entry not found'
    redirect_to :action => :index
  end

  def tour_entry_params
    params.fetch(:tour_entry, {}).permit(:tour_id, :location, :bin, :sku,
      :barcode, :batch_code, :quantity, :active, :location_code, :bin_code)
  end

  def load_tour_relationships
    @locations = Location.accessible_by(current_ability).pluck(:code)
    @sku = Product.accessible_by(current_ability).pluck(:sku)+ []
    @bin_codes = StockLevel.accessible_by(current_ability).pluck(:bin_code)+ []
    @barcodes = ProductBarcode.accessible_by(current_ability).pluck(:barcode)+ []
    @batch_codes = StockLevel.accessible_by(current_ability).pluck(:batch_code) + []
    @tours = Tour.options_for_select(current_ability)
  end

  def only_variance_to_bool
    params[:only_variance] == 'true' ? true : false
  end

  def load_tour_entries
    if params[:id]
      @tour_entries = TourEntry.where(:id => params[:id])
    else
      @tour_entries = TourEntry.accessible_by(current_ability).only_variance(only_variance_to_bool).joins(:tour).select(select_fields)
    end
  end

  def select_fields
    "
     tours.name as tour_name,
     tours.id as tour_id,
     tour_entries.id,
     tour_entries.location_code,
     tour_entries.bin_code,
     tour_entries.sku,
     tour_entries.barcode,
     tour_entries.batch_code,
     tour_entries.stock_level_qty,
     tour_entries.quantity,
     tour_entries.variance
    "
  end
end
