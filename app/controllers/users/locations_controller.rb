class Users::LocationsController < Users::AdminController

  before_action :build_location,  :only => [:new, :create]
  before_action :load_location,   :only => [:show, :edit, :update, :destroy]

  def index
    @locations = Location.accessible_by(current_ability) #.page(params[:page])
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
    @location.company = current_company if current_company
    @location.save!
    flash[:success] = 'Location created'
    redirect_to :action => :show, :id => @location
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Location'
    render :action => :new
  end

  def update
    @location.update_attributes!(location_params)
    flash[:success] = 'Location updated'
    redirect_to :action => :show, :id => @location
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Location'
    render :action => :edit
  end

  def destroy
    @location.destroy
    flash[:success] = 'Location deleted'
    redirect_to :action => :index
  end

protected

  def build_location
    @location = Location.new(location_params)
  end

  def load_location
    @location = Location.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Location not found'
    redirect_to :action => :index
  end

  def location_params
    params.fetch(:location, {}).permit(:code, :name, :phone, :email, :address, :address2, :address3, :suburb, :state, :postcode, :country, :description)
  end
end
