class Users::ToursController < Users::AdminController

  before_action :build_tour,  :only => [:new, :create]
  before_action :load_tour,   :only => [:show, :edit, :update, :destroy]
  before_action :load_users, :only => [:new, :edit]
  before_action :append_tour_entries, only: :create

  respond_to :csv, :html

  def index
    @tours = Tour.accessible_by(current_ability) #.page(params[:page])
  end

  def download
    respond_to do |format|
      format.csv { send_data Tour.to_csv(current_ability), filename: "tours-#{Date.today}.csv" }
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
      @processor.process
      @tour.entries << @processor.entries
      Rails.cache.write(stock_levels_data_key, nil)
    end
  end

  def stock_levels_data_key
    "#{current_company.id}-stock-levels-#{current_user.id}"
  end

  def build_tour
    @tour = Tour.new(tour_params)
  end

  def load_users
    @users = User.accessible_by(current_ability)
    @users = @users.map { |a| [a.username, a.id] }
  end

  def load_tour
    @tour = Tour.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Tour not found'
    redirect_to :action => :index
  end

  def tour_params
    params.fetch(:tour, {}).permit(:name,
      :user_id, :active, :started, :completed)
  end
end
