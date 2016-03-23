class V1::ToursController < V1::BaseController
  api!
  desc "Returns ALL accessible by a admin/manager/operator tours
    GET /api/v1/tours.json?auth[token]=c4c7-7e32&since=2015-08-04T10:24:35.729Z
  "
  param :since, String, desc: 'Displays tours since the date, eg "2015-08-04T10:24:35.729Z"'
  def index
    @tours = Tour.accessible_by(current_ability).since(since_params[:since])
    render json: @tours
  end

  api!
  desc "Returns a SINGLE tour entry accessible by a admin/manager tours
    GET /api/v1/tours/1.json?auth[token]=c4c7-7e32
  "
  def show
    render json: @tour
  end

  api!
  desc "Creates tour entry item
    POST /api/v1/tours.json?auth[token]=c4c7-7e32&name=TOURNAME
  "
  param :tour, Hash, required: true do
    param :name,    String, required: true
    param :active,  String
    param :started, String
    param :entries_attributes, Array, desc: 'An array of tour entries'
  end
  def create
    @tour = Tour.create!(tour_params.merge(company_params))
    render json: @tour
  end

  api!
  desc "Creates tour entry item
    PUT /api/v1/tours/1.json?auth[token]=c4c7-7e32&name=TOURNAME
  "
  param :tour, Hash, required: true do
    param :name,      String, required: true
    param :active,    String, desc: 'Boolean, pass "true" or "false"'
    param :started,   String, desc: 'DateTime, eg "2015-08-04T10:24:35.729Z"'
    param :completed, String, desc: 'DateTime, eg "2015-08-04T10:24:35.729Z"'
    param :entries_attributes, Array, desc: 'An array of tour entries'
  end
  def update
    @tour.update_attributes!(tour_params)
    render json: @tour
  end

  api!
  desc "Deletes a tour entry
    DELETE /api/v1/tours/1.json?auth[token]=c4c7-7e32"
  def destroy
    @tour.destroy
    render json: @tour
  end

protected

  def tour_params
    params.require(:tour).permit(:name, :active, :started, :completed, :entries_attributes => [
      :location_code,
      :bin_code,
      :sku,
      :barcode,
      :batch_code,
      :quantity,
      :active,
      :visible,
      :changed_at,
    ])
  end
end
