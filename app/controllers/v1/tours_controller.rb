class V1::ToursController < V1::BaseController
  load_and_authorize_resource :except => [:create]

  def index
    @tours = Tour.accessible_by(current_ability).since(since_params)
    render json: @tours
  end

  def show
    render json: @tour
  end

  def create
    @tour = Tour.create!(tour_params.merge(company_params))
    render json: @tour
  end

  def update
    @tour.update_attributes!(tour_params)
    render json: @tour
  end

  def destroy
    @tour.destroy
    render json: @tour
  end

protected

  def tour_params
    params.require(:tour).permit(:name, :active, :started, :completed)
  end
end
