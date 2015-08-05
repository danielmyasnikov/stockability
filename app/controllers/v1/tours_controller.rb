class V1::ToursController < V1::BaseController
  load_and_authorize_resource :except => [:create]

  api!
  desc 'Returns ALL accessible by a admin/manager/operator tours'
  param :since, String, desc: 'Displays tours since the date, eg "14-july-2015"'
  def index
    @tours = Tour.accessible_by(current_ability).since(since_params)
    render json: @tours
  end

  api!
  desc 'Returns a SINGLE tour entry accessible by a admin/manager tours'
  def show
    render json: @tour
  end

  api!
  desc 'Creates tour entry item'
  param :tour, Hash, required: true do
    param :name,      String, required: true
    param :active,    String
  end
  def create
    @tour = Tour.create!(tour_params.merge(company_params))
    render json: @tour
  end

  api!
  desc 'Creates tour entry item'
  param :tour, Hash, required: true do
    param :name,      String, required: true
    param :active,    String
    param :started,   String
    param :completed, String
  end
  def update
    @tour.update_attributes!(tour_params)
    render json: @tour
  end

  api!
  desc 'Deletes a tour entry (by database ID)'
  def destroy
    @tour.destroy
    render json: @tour
  end

protected

  def tour_params
    params.require(:tour).permit(:name, :active, :started, :completed)
  end
end
