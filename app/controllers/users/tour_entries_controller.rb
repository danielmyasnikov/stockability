class Users::TourEntriesController < Users::AdminController
  skip_load_and_authorize_resource only: [
                                      :adjust_variance, 
                                      :reject_variance, 
                                      :assign_tour]

  # load accissible only and joined with tours tour_entries
  before_action :load_tour_entries, only: [
                                      :index,
                                      :adjust_variance, 
                                      :reject_variance, 
                                      :assign_tour]

  before_action :load_tour_entries_for_index, only: :index
                                      
  before_action :load_tour_entries_for_actions, only: [
                                      :adjust_variance, 
                                      :reject_variance, 
                                      :assign_tour]
  
  before_action :build_tour_entry,  only: [:new, :create]
  before_action :load_tour_entry,   only: [:show, :edit, :update, :destroy]
  
  before_action :load_tour_relationships, only: [
                                      :new,
                                      :create,
                                      :edit,
                                      :update]

  before_action :load_tour,         only: :assign_tour

  def index
    @tour_options = Tour.accessible_by(current_ability)
  end

  def scoped_by_tour
    # only_variance flag
    @tour_options = Tour.accessible_by(current_ability)
    @tour_entries = TourEntry.accessible_by(current_ability).where(filter_params)
    # render template: 'users/tour_entries/index'
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

  def assign_tour
    @tour_entries.update_all(:tour_id => @tour.id)
    tentries = @tour_entries.map { |x| [x.id, x.tour_name, x.tour_id] }
    render json: { ok: true, tour_entries: tentries }
  end

  def adjust_variance
    # PERFORMANCE optimized solution
    # @tour_entries.pluck(:id, :quantity).each do |te|
    #   # for performance reasons using update_all as it doesn't initialize object
    #   TourEntry.where(:id => te.first).update_all(stock_level_qty: te.second)
    # end

    # CALLBACK optimized solution
    # @tour_entries.pluck(:id, :stock_level_qty, :variance).each do |te|
    #   qty = te.second + te.third
    #   TourEntry.find(te.first).update_attributes(stock_level_qty: qty, quantity: qty)
    # end
    failed = false
    @tour_entries.each do |tour_entry|
      begin
        tour_entry.adjust_variance
      rescue ActiveRecord::RecordInvalid
        failed = true
      end
    end
    # render json: { ok: true, tour_entries: @tour_entries.pluck(:id, :stock_level_qty) }
    flash[:danger] = 'Something went wrong' if failed
    # redirect_to :back
    render json: { ok: true }
  end

  def reject_variance
    # PERFORMANCE optimized solution
    # @tour_entries.pluck(:id, :stock_level_qty).each! do |te|
    #   # for performance reasons using update_all as it doesn't initialize object
    #   TourEntry.where(:id => te.first).update_all(quantity: te.second)
    # end
    # redirect_to :index

    # CALLBACK solution
    # @tour_entries.pluck(:id, :stock_level_qty).each do |te|
    #   # for performance reasons using update_all as it doesn't initialize object
    #   TourEntry.find(te.first).update_attribute(:quantity, te.second)
    # end
    @tour_entries.map(&:reject_variance)
    # render json: { ok: true, tour_entries: @tour_entries.pluck(:id, :stock_level_qty) }
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
    @locations   = Location.accessible_by(current_ability).pluck(:code)
    @sku         = Product.accessible_by(current_ability).pluck(:sku)+ []
    @bin_codes   = StockLevel.accessible_by(current_ability).pluck(:bin_code)+ []
    @barcodes    = ProductBarcode.accessible_by(current_ability).pluck(:barcode)+ []
    @batch_codes = StockLevel.accessible_by(current_ability).pluck(:batch_code) + []
    @tours       = Tour.options_for_select(current_ability)
  end

  def only_variance_to_bool
    params[:only_variance] == 'true' ? true : false
  end

  def load_tour_entries
    @tour_entries = TourEntry.accessible_by(current_ability).joins(:tour)
  end

  def load_tour_entries_for_actions
    @tour_entries = @tour_entries.where(:stock_level_id => params[:stock_level_id],
                                        :tour_id => params[:tour_id]
    )
  end

  def load_tour_entries_for_index
    @tour_entries = @tour_entries.
      only_variance(only_variance_to_bool).
      select(select_fields).
      group(group_fields)
  end

  def group_fields
    "stock_level_id, tours.name, tours.id, location_code, bin_code, sku, barcode, tour_entries.company_id"
  end

  def load_tour
    @tour = Tour.find(params[:tour_id])
  end

  def select_fields
    "
     tours.name as tour_name,
     tours.id   as tour_id,
     tour_entries.location_code,
     tour_entries.bin_code,
     tour_entries.sku,
     tour_entries.barcode,
     avg(tour_entries.stock_level_qty) as sum_stock_level_qty,
     avg(tour_entries.quantity) as sum_quantity,
     avg(tour_entries.variance) as sum_variance,
     tour_entries.company_id,
     tour_entries.stock_level_id
    "
  end

  def filter_params
    str = {}
    if params[:tour_id]; str.merge!(tour_id: params[:tour_id]) end
    if params[:stock_level_id]; str.merge!(stock_level_id: params[:stock_level_id]) end
    str
  end
end
