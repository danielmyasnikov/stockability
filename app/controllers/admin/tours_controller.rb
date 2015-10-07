class Admin::ToursController < Comfy::Admin::Cms::BaseController

  before_action :build_tour,  :only => [:new, :create]
  before_action :load_tour,   :only => [:show, :edit, :update, :destroy]
  before_action :append_tour_entries, only: :create

  respond_to :csv, :html

  def index
    @tours = Tour.accessible_by(current_ability).page(params[:page])
    respond_to do |format|
      format.html { render }
      format.csv { render :csv => Tour.accessible_by(current_ability) }
    end
  end

  def show
    respond_to do |format|
      format.html {render}
      format.csv { render text: @tour.to_csv }
    end
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @tour.company = current_company if current_company
    @tour.save!
    flash[:success] = 'Tour created'
    redirect_to :action => :show, :id => @tour
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Tour'
    render :action => :new
  end

  def update
    @tour.update_attributes!(tour_params)
    flash[:success] = 'Tour updated'
    redirect_to :action => :show, :id => @tour
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Tour'
    render :action => :edit
  end

  def destroy
    @tour.destroy
    flash[:success] = 'Tour item has been deleted'
    redirect_to :action => :index
  end

protected

  def append_tour_entries
    @processor = Rails.cache.read(stock_levels_data_key)
    if @processor.present?
      @tour.tour_entries <<  @processor.tour_entries
      Rails.cache.write(stock_levels_data_key, nil)
    end
  end

  def stock_levels_data_key
    "#{current_company.id}-stock-levels"
  end

  def build_tour
    @tour = Tour.new(tour_params)
  end

  def load_tour
    @tour = Tour.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Tour not found'
    redirect_to :action => :index
  end

  def tour_params
    params.fetch(:tour, {}).permit(:name,
      :admin_id, :active, :started, :completed)
  end
end
