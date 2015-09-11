class V1::ToursController < V1::BaseController
  load_and_authorize_resource :except => [:create]

  api!
  desc 'Returns ALL accessible by a admin/manager/operator tours'
  param :since, String, desc: 'Displays tours since the date, eg "2015-08-04T10:24:35.729Z"'
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
    param :name,    String, required: true
    param :active,  String
    param :started, String
  end
  def create
    @tour = Tour.create!(tour_params.merge(company_params))
    render json: @tour
  end

  api!
  desc 'Creates tour entry item'
  param :tour, Hash, required: true do
    param :name,      String, required: true
    param :active,    String, desc: 'Boolean, pass "true" or "false"'
    param :started,   String, desc: 'DateTime, eg "2015-08-04T10:24:35.729Z"'
    param :completed, String, desc: 'DateTime, eg "2015-08-04T10:24:35.729Z"'
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
