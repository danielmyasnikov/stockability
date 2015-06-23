class Admin::TourEntriesController < Comfy::Admin::Cms::BaseController

  before_action :build_tour_entry,  :only => [:new, :create]
  before_action :load_tour_entry,   :only => [:show, :edit, :update, :destroy]

  def index
    @tour_entries = TourEntry.page(params[:page])
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
    params.fetch(:tour_entry, {}).permit(:tour, :location, :bin, :sku, :barcode, :batch_code, :quantity, :active)
  end
end