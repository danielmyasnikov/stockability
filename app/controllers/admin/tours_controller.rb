class Admin::TourController < Comfy::Admin::Cms::BaseController

  before_action :build_tour,  :only => [:new, :create]
  before_action :load_tour,   :only => [:show, :edit, :update, :destroy]

  def index
    @tours = Tour.accessible_by(current_ability).page(params[:page])
  end

  def show
    render
  end

  # def new
  #   render
  # end

  # def edit
  #   render
  # end

  # def create
  #   @session.save!
  #   flash[:success] = 'Session created'
  #   redirect_to :action => :show, :id => @session
  # rescue ActiveRecord::RecordInvalid
  #   flash.now[:danger] = 'Failed to create Session'
  #   render :action => :new
  # end

  # def update
  #   @session.update_attributes!(session_params)
  #   flash[:success] = 'Session updated'
  #   redirect_to :action => :show, :id => @session
  # rescue ActiveRecord::RecordInvalid
  #   flash.now[:danger] = 'Failed to update Session'
  #   render :action => :edit
  # end

  def destroy
    @tour.destroy
    flash[:success] = 'Tour item has been deleted'
    redirect_to :action => :index
  end

protected

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
    params.fetch(:tour, {}).permit(:name)
  end
end
